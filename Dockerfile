FROM php:8.2-apache


RUN apt-get update && apt-get install -y libzip-dev zip unzip \
    && docker-php-ext-install zip


RUN pecl install mongodb-2.1.2 && docker-php-ext-enable mongodb

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer


WORKDIR /var/www/html


COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader


COPY . /var/www/html

RUN composer dump-autoload --optimize --no-dev
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

