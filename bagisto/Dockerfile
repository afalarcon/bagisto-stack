FROM php:8.2-fpm

# Paquetes del sistema y extensiones PHP
RUN apt-get update && apt-get install -y \
    ca-certificates curl unzip \
    libzip-dev libpng-dev libonig-dev libxml2-dev libicu-dev libjpeg62-turbo-dev libfreetype6-dev \
 && docker-php-ext-configure intl \
 && docker-php-ext-install pdo pdo_mysql zip gd intl bcmath opcache \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_MEMORY_LIMIT=-1

WORKDIR /var/www/html

# ↓↓↓ SIN '&&' encadenados ↓↓↓
ARG BAGISTO_REF=master
RUN curl -fsSL "https://codeload.github.com/bagisto/bagisto/tar.gz/refs/heads/${BAGISTO_REF}" -o /tmp/bagisto.tar.gz
RUN tar -xzf /tmp/bagisto.tar.gz -C /var/www/html --strip-components=1
RUN composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader --no-progress

# Permisos
RUN chown -R www-data:www-data /var/www/html
RUN find storage -type d -exec chmod 775 {} \;
RUN find bootstrap/cache -type d -exec chmod 775 {} \;

# Entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm"]
