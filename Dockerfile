FROM php:7.2-fpm-alpine

RUN docker-php-source extract \
    # Add some build packages
    && apk add --no-cache --virtual .dependencies \
        $PHPIZE_DEPS \
        freetype-dev \
        imagemagick-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libxml2-dev \
        postgresql-dev \
        sqlite-dev \
    # Add some persistent packages
    && apk add --no-cache \
        bash \
        freetype \
        imagemagick-libs \
        libjpeg-turbo \
        libpng \
        libwebp \
        libxml2 \
        postgresql-libs \
        sqlite-libs \
    # Set configuration for GD
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include \
        --with-jpeg-dir=/usr/include \
        --with-png-dir=/usr/include \
        --with-webp-dir=/usr/include \
    # Add some Extensions
    && docker-php-ext-install \
        ctype \
        iconv \
        gd \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        pcntl \
        posix \
        tokenizer \
        xml \
        zip \
    # Install Imagick from Pecl
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    # Clean up
    && pecl clear-cache \
    && apk del --purge .dependencies \
    && docker-php-source delete

# Make errors log to STDOUT
RUN sed -i 's/\;error_log.*/error_log = \/proc\/self\/fd\/2/' /usr/local/etc/php-fpm.conf

COPY ./php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www
