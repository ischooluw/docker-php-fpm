FROM php:7.4-fpm-alpine

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
        libxml2-dev \
        libzip-dev \
        # postgresql-dev \
        sqlite-dev \
        unixodbc-dev \
    # Add some persistent packages
    && apk add --no-cache \
        bash \
        freetds \
        freetype \
        imagemagick-libs \
        libjpeg-turbo \
        libpng \
        libwebp \
        libxml2 \
        libzip \
        # postgresql-libs \
        tzdata \
        unixodbc \
        sqlite-libs \
    # Set configuration for GD
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
    # Add some Extensions
    && docker-php-ext-install \
        ctype \
        iconv \
        gd \
        pdo \
        pdo_dblib \
        pdo_mysql \
        pdo_odbc \
        # pdo_pgsql \
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
