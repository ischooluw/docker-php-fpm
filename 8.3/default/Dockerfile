FROM php:8.3.11-fpm

RUN docker-php-source extract \
    # Install dependencies and build tools
    && apt-get update && apt-get install -y --no-install-recommends \
        $PHPIZE_DEPS \
        freetds-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev \
        zlib1g-dev \
        libpcre3-dev \
        unixodbc-dev \
    # Set up some persistent packages
    && apt-get install -y --no-install-recommends \
        libzip4 \
        zlib1g \
        tzdata \
        autoconf \
        build-essential \
        unzip \
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
    # Clean up
    && pecl clear-cache \
    && apt-get remove --purge -y $PHPIZE_DEPS \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
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
