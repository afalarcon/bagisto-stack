FROM php:8.2-fpm

# Dependencias PHP
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libonig-dev libxml2-dev libicu-dev libjpeg62-turbo-dev libfreetype6-dev \
 && docker-php-ext-configure intl \
 && docker-php-ext-install pdo pdo_mysql zip gd intl bcmath opcache \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Clona Bagisto (puedes cambiar a tu fork)
RUN git clone --depth 1 https://github.com/bagisto/bagisto.git . \
 && composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader

# Permisos
RUN chown -R www-data:www-data /var/www/html \
 && find storage -type d -exec chmod 775 {} \; \
 && find bootstrap/cache -type d -exec chmod 775 {} \;

# Entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm"]
