FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libssl-dev \
    pkg-config \
    && docker-php-ext-install zip

RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer



WORKDIR /var/www/html

COPY . /var/www/html

RUN composer install --no-dev 

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
