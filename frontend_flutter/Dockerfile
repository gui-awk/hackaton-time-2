# Etapa 1: Build do Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copia os arquivos do projeto
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# Build para web em modo release
RUN flutter build web --release

# Etapa 2: Servidor Nginx para servir os arquivos estáticos
FROM nginx:alpine

# Copia os arquivos buildados para o Nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Configuração customizada do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
