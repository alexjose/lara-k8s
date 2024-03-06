FROM node:20 AS node
WORKDIR /app
COPY . /app
RUN npm install 
RUN npm run build
RUN rm -rf /app/node_modules

FROM ghcr.io/alexjose/lara-k8s-php-fpm:latest

COPY --from=node /app /app
WORKDIR /app
COPY .env.example .env

RUN composer install
RUN php artisan key:generate

CMD php artisan serve --host=0.0.0.0 --port=80
EXPOSE 80