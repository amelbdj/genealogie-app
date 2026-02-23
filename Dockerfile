FROM composer:2 AS build
WORKDIR /app
COPY composer.* ./
RUN composer install --no-dev --no-interaction --no-scripts

FROM php:8.2-apache
WORKDIR /var/www/html
COPY --from=build /app /var/www/html
RUN chown -R www-data:www-data /var/www/html
