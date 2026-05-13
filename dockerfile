FROM node:20-alpine AS builder

WORKDIR /app

RUN apk add --no-cache python3 make g++ build-base git

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build -- --configuration production

FROM nginxinc/nginx-unprivileged:alpine

WORKDIR /usr/share/nginx/html

COPY --from=builder --chown=nginx:nginx /app/dist/casino-frontend/browser/ ./

COPY --chown=nginx:nginx nginx.conf /etc/nginx/conf.d/default.conf

USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
