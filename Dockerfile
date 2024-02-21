FROM node:20 AS node
WORKDIR /app
COPY . /app
RUN npm install 
RUN npm run build
RUN rm -rf /app/node_modules

FROM php:8.2-cli

RUN apt-get update -y && apt-get install -y openssl zip unzip git libonig-dev
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install pdo mbstring

COPY --from=node /app /app
WORKDIR /app
COPY .env.example .env

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install
RUN php artisan key:generate

CMD php artisan serve --host=0.0.0.0 --port=80
EXPOSE 80