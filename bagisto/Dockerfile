FROM php:8.2-fpm
ENV DEBIAN_FRONTEND=noninteractive

# Sistema + extensiones PHP
RUN apt-get update && apt-get install -y \
    ca-certificates curl unzip git \
    libzip-dev libpng-dev libonig-dev libxml2-dev libicu-dev \
    libjpeg62-turbo-dev libfreetype6-dev \
 && docker-php-ext-configure intl \
 && docker-php-ext-install pdo pdo_mysql zip gd intl bcmath opcache \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_MEMORY_LIMIT=-1 COMPOSER_PROCESS_TIMEOUT=2000

# ↓ Trabajamos SIEMPRE en /usr/src/bagisto (código base)
WORKDIR /usr/src/bagisto
ARG BAGISTO_REF=master
RUN curl -fsSL "https://codeload.github.com/bagisto/bagisto/tar.gz/refs/heads/${BAGISTO_REF}" -o /tmp/bagisto.tar.gz
RUN tar -xzf /tmp/bagisto.tar.gz -C /usr/src/bagisto --strip-components=1

# (Opcional) token para evitar rate limit
ARG GITHUB_TOKEN=""
RUN if [ -n "$GITHUB_TOKEN" ]; then composer config -g github-oauth.github.com "$GITHUB_TOKEN"; fi

# Instala dependencias en /usr/src/bagisto
RUN set -e; for i in 1 2 3; do \
      composer install --no-dev --prefer-dist --no-interaction --no-progress -vvv && break || \
      (composer clear-cache && sleep 5); \
    done

# Entrypoint y CMD
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
# El runtime usará /var/www/html (volumen) — el entrypoint copiará si está vacío
WORKDIR /var/www/html
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
