# BUILDER / RUNNER
FROM php:8.2-fpm AS build

# System packages and PHP extensions
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    locales \
    libicu-dev \
    g++ \
    && docker-php-ext-install -j$(nproc) gd mbstring pdo pdo_mysql zip bcmath intl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && pecl install redis timezonedb \
    && echo "extension=timezonedb.so" > /usr/local/etc/php/conf.d/docker-php-ext-timezonedb.ini \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini

# Locale Configuration
RUN echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Timezone Configuration
ENV TZ=America/Sao_Paulo
RUN echo "date.timezone=${TZ}" > /usr/local/etc/php/conf.d/timezone.ini

# Composer Configuration
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Workdir configuration
WORKDIR /var/www/api

## Composer Install
RUN mkdir -p /var/www/api
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

## Build
ADD . /var/www/api/.
RUN /usr/bin/composer install

# Install Laravel App
RUN mkdir -p /var/log/laravel
ADD .env.example /var/www/api/.env
RUN php artisan storage:link

# Configuração de permissões
RUN chown -R www-data:www-data /var/www/api \
    && chmod -R 777 /var/www/api/storage \
    && chmod -R 777 /var/www/api/storage/logs \
    && chmod -R 777 /var/www/api/bootstrap/cache \
    && chmod -R 777 /var/log/laravel

# Logs Symlink
RUN rm -Rf /var/log/laravel
RUN ln -s /var/www/api/storage/logs /var/log/laravel

# Cleanup
RUN rm -Rf /var/cache/apt/archives/*

# Volume to persist the aplication code
VOLUME ["/var/www/api"]

# PHP-FPM comand initialization
RUN echo "listen = 9000" >> /usr/local/etc/php-fpm.d/zz-docker.conf
CMD ["php-fpm"]
