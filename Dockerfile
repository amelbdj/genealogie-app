FROM php:8.2-apache

# 1. Installation des dépendances système en une seule fois
# On ajoute pkg-config et libcurl pour aider la compilation de MongoDB
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    pkg-config \
    && docker-php-ext-install zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Installation de MongoDB (PECL)
# On fixe la version pour éviter les surprises, 2.1.2 est correct pour PHP 8.2
RUN pecl install mongodb-2.1.2 && docker-php-ext-enable mongodb

# 3. Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 4. Configuration Apache
RUN a2enmod rewrite

WORKDIR /var/www/html

# 5. Optimisation du cache Composer
# On copie d'abord les fichiers composer pour ne pas réinstaller les vendors
# à chaque modification de votre code source PHP.
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader

# 6. Copier le reste du projet
COPY . /var/www/html

# 7. Finaliser Composer et Permissions
RUN composer dump-autoload --optimize --no-dev
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
