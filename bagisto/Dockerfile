FROM php:8.2-fpm

# Dependencias del sistema
RUN apt-get update && apt-get install -y \
    git ca-certificates curl unzip \
    libzip-dev libpng-dev libonig-dev libxml2-dev libicu-dev libjpeg62-turbo-dev libfreetype6-dev \
 && docker-php-ext-configure intl \
 && docker-php-ext-install pdo pdo_mysql zip gd intl bcmath opcache \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_MEMORY_LIMIT=-1

WORKDIR /var/www/html

# Clonar Bagisto (puedes fijar una tag estable con --branch v2.2.0 si quieres)
RUN git clone --depth 1 https://github.com/bagisto/bagisto.git . \
 && composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader --no-progress

# Permisos
RUN chown -R www-data:www-data /var/www/html \
 && find storage -type d -exec chmod 775 {} \; \
 && find bootstrap/cache -type d -exec chmod 775 {} \;

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
