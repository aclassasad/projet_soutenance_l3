FROM webdevops/php-nginx:8.2

# Répertoire de travail
WORKDIR /app

# Copier tout le projet Laravel
COPY . /app

# Installer les dépendances et optimiser Laravel
RUN composer install --no-dev --optimize-autoloader \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache \
    && chown -R application:application /app/storage /app/bootstrap/cache

# Définir la racine publique pour Nginx
ENV WEB_DOCUMENT_ROOT=/app/public

# Forcer Nginx à utiliser le bon socket PHP-FPM
ENV PHP_SOCKET=unix:/var/run/php-fpm.sock

# Exposer le port 80
EXPOSE 80

# Démarrage supervisé (Nginx + PHP-FPM)
CMD ["supervisord"]
