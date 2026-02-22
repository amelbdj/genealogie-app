FROM php:8.2-apache

RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.* ./
RUN composer install --no-dev --no-interaction --no-scripts

COPY . .

RUN chown -R www-data:www-data /var/www/html
