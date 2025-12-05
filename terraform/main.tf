# ============================================
# Central do Cidadão - Terraform AWS EC2
# ============================================

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configurar provider AWS
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile  # Perfil do AWS CLI (configure no variables.tf)
}

# Data source para pegar a AMI mais recente do Ubuntu 22.04
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group - Liberar portas necessárias
resource "aws_security_group" "central_cidadao_sg" {
  name        = "central-cidadao-sg"
  description = "Security group para Central do Cidadao"
  vpc_id      = var.vpc_id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  # HTTP (Frontend)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Frontend"
  }

  # Frontend (porta 3000)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Frontend Flutter"
  }

  # Backend API (porta 8080)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Backend API"
  }

  # MySQL (apenas para debug, remover em produção)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "MySQL"
  }

  # Saída - permitir tudo
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "central-cidadao-sg"
    Project = "Central do Cidadao"
  }
}

# EC2 Instance
resource "aws_instance" "central_cidadao" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.central_cidadao_sg.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true

  # Disco
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  # User data - Script de inicialização
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    git_repo     = var.git_repo
    git_branch   = var.git_branch
    db_password  = var.db_password
  }))

  tags = {
    Name    = "central-cidadao-ec2"
    Project = "Central do Cidadao"
  }
}

# Elastic IP (IP fixo)
resource "aws_eip" "central_cidadao_eip" {
  instance = aws_instance.central_cidadao.id
  domain   = "vpc"

  tags = {
    Name    = "central-cidadao-eip"
    Project = "Central do Cidadao"
  }
}
