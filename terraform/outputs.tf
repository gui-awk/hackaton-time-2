# ============================================
# Outputs do Terraform
# ============================================

output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.central_cidadao.id
}

output "public_ip" {
  description = "IP público da instância"
  value       = aws_eip.central_cidadao_eip.public_ip
}

output "frontend_url" {
  description = "URL do Frontend"
  value       = "http://${aws_eip.central_cidadao_eip.public_ip}:3000"
}

output "backend_url" {
  description = "URL do Backend API"
  value       = "http://${aws_eip.central_cidadao_eip.public_ip}:8080"
}

output "swagger_url" {
  description = "URL do Swagger UI"
  value       = "http://${aws_eip.central_cidadao_eip.public_ip}:8080/swagger-ui.html"
}

output "ssh_command" {
  description = "Comando para conectar via SSH"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_eip.central_cidadao_eip.public_ip}"
}
