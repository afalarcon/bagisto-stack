FROM php:8.2-fpm

ENV DEBIAN_FRONTEND=noninteractive

# Dependencias del sistema + extensiones PHP requeridas por Bagisto/Laravel
RUN apt-get update && apt-get install -y \
    ca-certificates curl unzip git \
    libzip-dev libpng-dev libonig-dev libxml2-dev libicu-dev \
    libjpeg62-turbo-dev libfreetype6-dev \
 && docker-php-ext-configure intl \
 && docker-php-ext-install pdo pdo_mysql zip gd intl bcmath opcache \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_PROCESS_TIMEOUT=2000

WORKDIR /var/www/html

# ↓ Descarga código (rama master) sin '&&' encadenados
ARG BAGISTO_REF=master
RUN curl -fsSL "https://codeload.github.com/bagisto/bagisto/tar.gz/refs/heads/${BAGISTO_REF}" -o /tmp/bagisto.tar.gz
RUN tar -xzf /tmp/bagisto.tar.gz -C /var/www/html --strip-components=1

# (OPCIONAL) Auth para evitar rate limit de GitHub: pasa --build-arg GITHUB_TOKEN=... en el stack
ARG GITHUB_TOKEN=""
RUN if [ -n "$GITHUB_TOKEN" ]; then \
      composer config -g --no-plugins --no-interaction --ansi \
        github-oauth.github.com "$GITHUB_TOKEN" ; \
    fi

# Composer install con RETRY (3 intentos) y verbose para ver el fallo real
RUN set -e; \
    for i in 1 2 3; do \
      composer install --no-dev --prefer-dist --no-interaction --no-progress -vvv && break || \
      (composer clear-cache && sleep 5); \
    done

# Permisos
RUN chown -R www-data:www-data /var/www/html
RUN find storage -type d -exec chmod 775 {} \;
RUN find bootstrap/cache -type d -exec chmod 775 {} \;

# Entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
