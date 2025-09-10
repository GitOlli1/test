# 1. Build Stage
FROM node:20-alpine AS builder

# Setze das Arbeitsverzeichnis
WORKDIR /app

# Kopiere package.json und package-lock.json / pnpm-lock.yaml
COPY package*.json ./

# Installiere Abhängigkeiten
RUN npm install
# Wenn du pnpm benutzt: RUN npm install -g pnpm && pnpm install

# Kopiere den Rest des Projekts
COPY . .

# Baue das Projekt
RUN npm run build
# Falls du pnpm benutzt: RUN pnpm build

# 2. Production Stage
FROM nginx:alpine

# Lösche Standard-Nginx-Dateien
RUN rm -rf /usr/share/nginx/html/*

# Kopiere die gebauten Dateien vom Builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Kopiere benutzerdefinierte Nginx-Konfiguration (optional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponiere Port 80
EXPOSE 80

# Starte Nginx
CMD ["nginx", "-g", "daemon off;"]