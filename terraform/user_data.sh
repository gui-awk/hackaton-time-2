#!/bin/bash
# ============================================
# Script de inicialização da EC2
# Central do Cidadão
# ============================================

set -e

# Log de tudo para debug
exec > >(tee /var/log/user-data.log) 2>&1
echo "Iniciando setup em $(date)"

# Atualizar sistema
apt-get update -y
apt-get upgrade -y

# Instalar dependências
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git

# Instalar Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Iniciar Docker
systemctl start docker
systemctl enable docker

# Adicionar ubuntu ao grupo docker
usermod -aG docker ubuntu

# Clonar repositório
cd /home/ubuntu
git clone ${git_repo} app
cd app
git checkout ${git_branch}

# Criar arquivo .env
cat > .env << EOF
DB_ROOT_PASSWORD=${db_password}
DB_NAME=central_cidadao
DB_USER=app_user
DB_PASSWORD=${db_password}
EOF

# Ajustar permissões
chown -R ubuntu:ubuntu /home/ubuntu/app

# Subir aplicação com Docker Compose
docker compose up -d --build

echo "Setup concluído em $(date)"
echo "Aplicação disponível em:"
echo "  Frontend: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):3000"
echo "  Backend:  http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"
echo "  Swagger:  http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080/swagger-ui.html"
