FROM php:8.2-apache

# Installer dépendances système
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libssl-dev \
    && docker-php-ext-install zip

# Installer PECL et MongoDB
RUN pecl install mongodb-2.1.2 && docker-php-ext-enable mongodb

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Activer mod_rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html

# Copier les fichiers du projet
COPY . /var/www/html

# Installer dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
