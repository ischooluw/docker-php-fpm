FROM php:5.6-fpm-alpine

RUN docker-php-source extract \
    # Add some build packages
    && apk add --no-cache --virtual .dependencies \
        $PHPIZE_DEPS \
        libxml2-dev \
        libzip-dev \
        # postgresql-dev \
        sqlite-dev \
    # Add some persistent packages
    && apk add --no-cache \
        bash \
        libxml2 \
        libzip \
        # postgresql-libs \
        tzdata \
        sqlite-libs \
    # Add some Extensions
    && docker-php-ext-install \
        ctype \
        iconv \
        pdo \
        pdo_mysql \
        mysqli \
        # pdo_pgsql \
        pdo_sqlite \
        pcntl \
        posix \
        tokenizer \
        xml \
        zip \
    # Clean up
    && apk del --purge .dependencies \
    && docker-php-source delete

# Make errors log to STDOUT
RUN sed -i 's/\;error_log.*/error_log = \/proc\/self\/fd\/2/' /usr/local/etc/php-fpm.conf

# Copy php.ini to image
COPY ./php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www
