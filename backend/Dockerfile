# Image de base avec PHP 8.2 + Nginx
FROM webdevops/php-nginx:8.2

# Définir le répertoire de travail
WORKDIR /app

# Copier tout le projet Laravel
COPY . /app

# Installer Composer et les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Définir la racine publique pour Nginx
ENV WEB_DOCUMENT_ROOT=/app/public

# Exposer le port 80
EXPOSE 80

# Commande de démarrage (Nginx + PHP-FPM sont déjà gérés par l'image)
CMD ["supervisord"]
