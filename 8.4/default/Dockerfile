FROM php:8.4.27-fpm-alpine3.24

RUN docker-php-source extract \
    # Add some build packages
    && apk add --no-cache --virtual .dependencies \
        $PHPIZE_DEPS \
        freetds-dev \
        freetype-dev \
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
        libjpeg-turbo \
        libpng \
        libwebp \
        libzip \
        tzdata \
        unixodbc \
    # Set configuration for GD
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
    # Add PHP Redis (pinned GitHub release; pecl.php.net downloads were timing out)
    && mkdir -p /usr/src/php/ext/redis \
    && curl -fsSL https://github.com/phpredis/phpredis/archive/refs/tags/6.3.0.tar.gz -o /tmp/phpredis.tar.gz \
    && echo "cb8f81df1a275599e4f8ddcfec7e1f65ed1953e6f5673649149fd680ebff4cad  /tmp/phpredis.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/phpredis.tar.gz -C /usr/src/php/ext/redis --strip-components=1 \
    && rm /tmp/phpredis.tar.gz \
    # Add some Extensions
    && docker-php-ext-install \
        gd \
        pdo_dblib \
        pdo_mysql \
        pdo_odbc \
        pcntl \
        redis \
        zip \
    # Cleanup
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
