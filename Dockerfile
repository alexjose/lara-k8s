FROM php:8.2-cli

RUN apt-get update -y && apt-get install -y openssl zip unzip git libonig-dev
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo mbstring
WORKDIR /app
COPY . /app

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install

CMD php artisan serve --host=0.0.0.0 --port=8181
EXPOSE 8181