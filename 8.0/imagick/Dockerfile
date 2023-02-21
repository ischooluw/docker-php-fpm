FROM php:8.0.28-fpm-alpine3.16

RUN docker-php-source extract \
    # Add some build packages
    && apk add --no-cache --virtual .dependencies \
        $PHPIZE_DEPS \
        freetds-dev \
        freetype-dev \
        imagemagick-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev \
        pcre-dev \
        unixodbc-dev \
    # Add some persistent packages
    && apk add --no-cache \
        freetds \
        freetype \
        imagemagick \
        imagemagick-libs \
        libjpeg-turbo \
        libpng \
        libwebp \
        libzip \
        php8-pecl-imagick \
        tzdata \
        unixodbc \
    # Set configuration for GD
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
    # Add PHP Redis
    && pecl install redis \
    && docker-php-ext-enable redis \
    # Add some Extensions
    && docker-php-ext-install \
        gd \
        pdo_dblib \
        pdo_mysql \
        pdo_odbc \
        pcntl \
        zip \
    # Install Imagick from Pecl
    && pecl install imagick \
    && docker-php-ext-enable --ini-name 20-imagick.ini imagick \
    # Clean up
    && pecl clear-cache \
    && apk del --purge .dependencies \
    && docker-php-source delete

# Copy ODBC Configs for MSSQL connection (contains UW EDW domain but no credentials)
COPY ./freetds.conf \
     ./odbc.ini \
     ./odbcinst.ini \
     /etc/

# Make errors log to STDOUT
RUN sed -i 's/\;error_log.*/error_log = \/proc\/self\/fd\/2/' /usr/local/etc/php-fpm.conf

# Copy php.ini to image
COPY ./php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www
