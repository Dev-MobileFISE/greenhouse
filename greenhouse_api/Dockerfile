# ==========================================
# Dockerfile - Backend Symfony API Platform
# ==========================================
FROM php:8.2-apache

# Installer les dépendances système et extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install \
    pdo \
    pdo_pgsql \
    intl \
    zip \
    opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Activer le module Apache rewrite (essentiel pour le routage Symfony)
RUN a2enmod rewrite

# Configurer Apache pour pointer sur le dossier /public de Symfony
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copier d'abord composer.json et composer.lock pour profiter du cache Docker
COPY composer.json composer.lock symfony.lock ./

# Installer les dépendances PHP sans exécuter les scripts tout de suite
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

# Copier l'intégralité du projet
COPY . .

# Finaliser l'installation Composer et générer l'autoloader optimisé
RUN composer dump-autoload --optimize --no-dev --classmap-authoritative \
    && composer run-script --no-dev post-install-cmd || true

# Droits d'écriture pour les dossiers de cache et logs
RUN chown -R www-data:www-data /var/www/html/var

EXPOSE 80

CMD ["apache2-foreground"]
