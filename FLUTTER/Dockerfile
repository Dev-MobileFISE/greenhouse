# ==========================================
# Étape 1 : Build de l'application Flutter Web
# ==========================================
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copier d'abord les fichiers de dépendances pour optimiser le cache Docker
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copier l'ensemble des fichiers du projet
COPY . .

# Compiler le projet en mode Web Release
RUN flutter build web --release

# ==========================================
# Étape 2 : Serveur Nginx ultra-léger
# ==========================================
FROM nginx:alpine

# Configuration Nginx pour SPA (Single Page Application)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier le build web généré par Flutter
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
