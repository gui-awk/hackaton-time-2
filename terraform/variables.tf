# ============================================
# Variáveis do Terraform
# ============================================

variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-2"  # Ohio - onde está sua VPC
}

variable "aws_profile" {
  description = "Perfil AWS CLI (configurado em ~/.aws/credentials)"
  type        = string
  default     = "default"  # ALTERE AQUI para o seu perfil
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
  default     = "vpc-01367bb93348e0739"
}

variable "subnet_id" {
  description = "ID da Subnet"
  type        = string
  default     = "subnet-07bb7ef82389821ab"  # us-east-2a
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.medium"  # 2 vCPU, 4GB RAM - suficiente para o MVP
}

variable "key_name" {
  description = "Nome da key pair para SSH"
  type        = string
  # ALTERE AQUI: nome da sua key pair existente na AWS
  # Exemplo: "minha-chave-aws"
}

variable "git_repo" {
  description = "URL do repositório Git"
  type        = string
  default     = "https://github.com/gui-awk/hackaton-time-2.git"
}

variable "git_branch" {
  description = "Branch do Git para deploy"
  type        = string
  default     = "feat/database"
}

variable "db_password" {
  description = "Senha do banco de dados MySQL"
  type        = string
  sensitive   = true
  default     = "SenhaSegura123!"  # ALTERE para produção!
}
