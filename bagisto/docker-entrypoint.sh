#!/usr/bin/env bash
set -e

echo "Esperando DB..."
until php -r "mysqli_report(MYSQLI_REPORT_OFF); \$c=mysqli_connect(getenv('DB_HOST'),getenv('DB_USERNAME'),getenv('DB_PASSWORD'),getenv('DB_DATABASE')); if(!\$c) exit(1);" ; do
  sleep 2
done

# .env
if [ ! -f .env ]; then
  cp .env.example .env
  sed -i "s|APP_URL=.*|APP_URL=${APP_URL}|g" .env
  sed -i "s|DB_HOST=.*|DB_HOST=${DB_HOST}|g" .env
  sed -i "s|DB_DATABASE=.*|DB_DATABASE=${DB_DATABASE}|g" .env
  sed -i "s|DB_USERNAME=.*|DB_USERNAME=${DB_USERNAME}|g" .env
  sed -i "s|DB_PASSWORD=.*|DB_PASSWORD=${DB_PASSWORD}|g" .env
fi

php artisan key:generate --force || true
php artisan migrate --force || true
php artisan db:seed --force || true
php artisan storage:link || true

exec "$@"
