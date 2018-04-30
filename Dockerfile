FROM php:7.2-fpm-alpine as ischool-php

# add php modules
RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    && apk add --no-cache \
        curl-dev \
        imagemagick-dev \
        libtool \
        libxml2-dev \
        postgresql-dev \
        sqlite-dev \
        # For GD
        freetype-dev \
        libjpeg-turbo \
        libpng-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
        curl \
        imagemagick \
        mysql-client \
        postgresql-libs \
    # Install Imagick from Pecl
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    # Threads
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    # Install PHP modules
    && docker-php-ext-install -j${NPROC} \
        curl \
        iconv \
        gd \
        mbstring \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        pcntl \
        tokenizer \
        xml \
        zip \
    # Configure GD
    && docker-php-ext-configure gd \
        --with-gd \
        --with-jpeg-dir=/usr/include \
        --with-png-dir=/usr/include \
        --with-webp-dir=/usr/include \
        --with-freetype-dir=/usr/include \
    # Clean up
    && apk del -f .build-deps

WORKDIR /var/www