FROM php:7.4-fpm-buster

RUN mkdir -p /usr/share/man/man1mkdir -p /usr/share/man/man1 \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash -  \
    && APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 \
    && apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        iputils-ping \
        curl \
        wget \
        git \
        vim \
        nano \
        bash \
        supervisor \
        nginx \
        nodejs \
        # Cerbot for nginx
        certbot \
        python-certbot-nginx \
        # PHP extension dependency
        zlib1g-dev \
        libpng-dev \
        libjpeg-dev \
        imagemagick \
        libfreetype6-dev \
        libxslt-dev \
        libzip-dev \
        # PHP LDAP extension dependency
        libldap2-dev \
        # PHP Mcrypt extension dependency
        libmcrypt-dev \
        # PHP Imagemagick extension dependency
        libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd \
        --with-jpeg \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-configure ldap \
        --with-libdir=lib/x86_64-linux-gnu/ \
    # Install defualt extension
    && docker-php-ext-install \
        bcmath \
        pdo \
        pdo_mysql \
        mysqli \
        gd \
        exif \
        xsl \
        soap \
        zip \
        opcache \
        intl \
        pcntl \
    && pecl install imagick-3.4.3 \
    && pecl install mcrypt-1.0.3 \
    && pecl install redis \
    && docker-php-ext-enable \
        imagick \
        mcrypt \
        redis \
    # Disable ImageMagick PDF security policies
    && sed -i '/^ *<!--/! s/<policy domain="coder" rights="none" pattern="PDF" \/>/<!-- <policy domain="coder" rights="none" pattern="PDF" \/> -->/' /etc/ImageMagick-6/policy.xml \
    # Delete extracted php source
    && docker-php-source delete

# Install Obfuscator-Class  
RUN curl -L -o /tmp/Obfuscator-Class.tar.gz "https://github.com/pH-7/Obfuscator-Class/archive/v2.0.1.tar.gz" \
    && mkdir -p /tmp/obfuscator \
    && mkdir -p /opt/obfuscator \
    && tar -C /tmp/obfuscator -zxf /tmp/Obfuscator-Class.tar.gz --strip 1 \
    && mv /tmp/obfuscator/src/Obfuscator.php /opt/obfuscator/Obfuscator_class.php \
    && rm -rf /tmp/obfuscator /tmp/Obfuscator-Class.tar.gz
COPY php/obfuscator.php /opt/obfuscator/obfuscator.php

# Install php composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

COPY supervisor /etc/supervisor
COPY php/zzz-app.conf /usr/local/etc/php-fpm.d/zzz-app.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/nginx-site.conf /etc/nginx/conf.d/default.conf

COPY macellan_default.php /var/www/html/public/macellan_default.php

COPY wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod o+x /usr/local/bin/wait-for-it

COPY docker-php-entrypoint /usr/local/bin/
RUN chmod o+x /usr/local/bin/docker-php-entrypoint

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]