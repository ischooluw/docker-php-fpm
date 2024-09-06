FROM php:8.3.8-fpm

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
        libpcre3-dev \
        unixodbc-dev \
        libmagickwand-dev \
    # Add persistent packages
    && apt-get install -y --no-install-recommends \
        freetds-bin \
        libfreetype6 \
        imagemagick \
        libjpeg62-turbo-dev \
        libpng16-16 \
        libwebp6 \
        libzip4 \
        tzdata \
        unixodbc \
    # Set configuration for GD
    && docker-php-ext-configure gd \
        --with-freetype=/usr/include/ \
        --with-jpeg=/usr/include/ \
        --with-webp=/usr/include/ \
    && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
    # Install PHP Redis
    && pecl install redis \
    && docker-php-ext-enable redis \
    # Add some PHP extensions
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

WORKDIR /var/ww
