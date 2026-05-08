# Dockerfile pour l'API mobile (JSON)
FROM webdevops/php-nginx:8.2

WORKDIR /var/www/html

COPY . .

RUN composer install --no-dev --optimize-autoloader
RUN php artisan config:cache && php artisan route:cache

# Expose le port 80 pour Render
EXPOSE 80
