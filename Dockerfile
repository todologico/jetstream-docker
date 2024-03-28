FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG USER_NAME=your_user
ARG USER_UID=1000
RUN useradd -u $USER_UID -ms /bin/bash $USER_NAME
RUN usermod -aG www-data $USER_NAME

RUN apt update

RUN apt install -y software-properties-common unzip curl iproute2 iputils-ping nano supervisor htop git
RUN add-apt-repository -y ppa:ondrej/php
RUN apt update
RUN apt install -y php8.3-cli php8.3-fpm php8.3-common php8.3-mysql php8.3-pgsql php8.3-zip php8.3-gd php8.3-mbstring php8.3-curl php8.3-ldap php8.3-xml php8.3-bcmath
RUN mkdir -p /var/run/php

RUN apt install -y nginx
RUN cd /etc/nginx/sites-available && rm *
RUN cd /etc/nginx/sites-enabled && rm *

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY www.conf /etc/php/8.3/fpm/pool.d/
COPY nginx.conf /etc/nginx/
COPY app.conf /etc/nginx/conf.d/
COPY docker-entrypoint.sh /usr/local/bin/
COPY supervisord.conf /etc/

VOLUME /var/www/app

RUN chmod -R 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]