FROM php:7.2-fpm-alpine as ischool-php

# add php modules
RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libtool \
        libwebp-dev \
        libxml2-dev \
        sqlite-dev \
    && apk add --no-cache \
        imagemagick-dev \
        postgresql-dev \
        bash \
    # Add some Extensions
    && docker-php-ext-install \
        ctype \
        iconv \
        # gd \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        pcntl \
        tokenizer \
        xml \
        zip \
    # Configure GD
    # && docker-php-ext-configure gd \
    #     --with-gd \
    #     --with-jpeg-dir=/usr/include \
    #     --with-png-dir=/usr/include \
    #     --with-webp-dir=/usr/include \
    #     --with-freetype-dir=/usr/include \
    # Install Imagick from Pecl
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    # Clean up
    && pecl clear-cache \
	&& rm -rf /tmp/pear ~/.pearrc \
	&& apk del .build-deps

# Make errors log to STDOUT
RUN sed -i 's/\;error_log.*/error_log = \/proc\/self\/fd\/2/' /usr/local/etc/php-fpm.conf


WORKDIR /var/www