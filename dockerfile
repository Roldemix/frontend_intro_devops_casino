# Etapa 1: Build de la aplicación Angular
FROM node:20-alpine AS builder

WORKDIR /app

# Instalar dependencias primero para aprovechar la caché de Docker
COPY package.json package-lock.json ./
RUN npm ci

# Copiar el código fuente y construir
COPY . .
# Asegúrate de que el script 'build' en tu package.json genere la carpeta 'dist/'
RUN npm run build -- --configuration production

# Etapa 2: Servidor Nginx unprivileged
FROM nginxinc/nginx-unprivileged:alpine

# Copiar el archivo de configuración personalizado de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar los archivos estáticos desde la etapa builder
# NOTA: Ajusta 'nombre-de-tu-app' por el nombre real que genera Angular en dist/
COPY --from=builder /app/dist/nombre-de-tu-app/browser /usr/share/nginx/html

# Exponer el puerto 8080 (puerto por defecto en la imagen unprivileged)
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]