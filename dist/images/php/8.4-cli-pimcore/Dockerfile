# syntax=docker/dockerfile:1
FROM php:8.4-cli-bullseye

LABEL org.opencontainers.image.authors="DevOps Team <devops@basecom.de>"
LABEL org.opencontainers.image.vendor="basecom GmbH & Co. KG"

# install composer from composer image
COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

# set timezone
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install system extensions
RUN apt-get update \
 && apt-get install -y lsb-release wget gnupg \
 && wget -qO - 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1> /dev/null \
 && echo "deb [arch=all,$(dpkg --print-architecture) signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | tee /etc/apt/sources.list.d/prebuilt-mpr.list \
 && echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" > /etc/apt/sources.list.d/backports.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    bash \
    bash-completion \
    chromium \
    chromium-sandbox \
    default-mysql-client \
    exiftool \
    facedetect \
    ffmpeg \
    ghostscript \
    graphviz \
    html2text \
    jpegoptim \
    just \
    libbz2-dev \
    libc-client-dev \
    libdjvulibre-dev \
    libfftw3-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    liblcms2-dev \
    libldap2-dev \
    libldap-common \
    liblqr-1-0-dev \
    libltdl-dev \
    liblzma-dev \
    libmagickwand-dev \
    locales \
    locales-all \
    libonig-dev \
    libopenexr-dev \
    libopenjp2-7-dev \
    libpango1.0-dev  \
    libpng-dev \
    librabbitmq-dev \
    libreoffice \
    librsvg2-dev \
    libtiff-dev \
    libwebp-dev \
    libwmf-dev \
    libx11-dev \
    libxext-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1.1 \
    libxslt1-dev \
    libxt-dev \
    libzip-dev \
    net-tools \
    opencv-data \
    pngcrush \
    poppler-utils \
    unzip \
    vim \
    webp \
    zlib1g-dev \
	    git \
    jq \
    less \
    nano \
    rsync \
    supervisor \
	 && apt-get autoremove -y \
 && apt-get remove -y gnupg \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
 && ln -s /usr/bin/chromium /usr/bin/chromium-browser

# install php extensions
RUN apt-get update \
 && apt-get install -y \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libz-dev \
    build-essential \
    g++ \
 && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
 && docker-php-ext-install intl mysqli bcmath gd bz2 soap xsl pdo_mysql fileinfo exif zip opcache ldap sockets \
 && pecl install redis apcu xdebug pcov amqp excimer \
 && mkdir -p /usr/src/php/ext/imagick \
 && curl -fsSL https://github.com/Imagick/imagick/archive/28f27044e435a2b203e32675e942eb8de620ee58.tar.gz | tar xvz -C /usr/src/php/ext/imagick --strip 1 \
 && docker-php-ext-enable redis apcu xdebug pcov amqp excimer \
 && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
 && docker-php-ext-install imap \
 && docker-php-ext-enable imap \
 && apt-get autoremove -y \
 && apt-get remove -y autoconf automake libtool pkg-config libz-dev build-essential g++ \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN if ! php -m | grep -q 'ftp'; then docker-php-ext-install ftp && docker-php-ext-enable ftp; fi
RUN if ! php -m | grep -q 'imagick'; then docker-php-ext-install imagick && docker-php-ext-enable imagick; fi
RUN if ! php -m | grep -q 'mbstring'; then docker-php-ext-install mbstring; fi
RUN if ! php -m | grep -q 'pdo'; then docker-php-ext-install pdo; fi

# install additional packages
# cjpeg
RUN if [ `uname -m` = "aarch64" ]; then \
      curl -fsSLO "https://github.com/imagemin/mozjpeg-bin/raw/main/vendor/linux/arm64/cjpeg"; \
    else \
      curl -fsSLO "https://github.com/imagemin/mozjpeg-bin/raw/main/vendor/linux/amd64/cjpeg"; \
    fi

RUN chmod 0755 cjpeg \
 && mv cjpeg /usr/local/bin/cjpeg

# Zopfli
RUN curl -fsSLO "https://github.com/imagemin/zopflipng-bin/raw/main/vendor/linux/zopflipng" \
 && chmod 0755 zopflipng \
 && mv zopflipng /usr/local/bin/zopflipng

# pngout
RUN curl -fsSLO "https://github.com/imagemin/pngout-bin/raw/main/vendor/linux/x64/pngout" \
 && chmod 0755 pngout \
 && mv pngout /usr/local/bin/pngout

# install supercronic
COPY php/install_supercronic.sh /opt/

RUN bash /opt/install_supercronic.sh

# configure xDebug
RUN echo "xdebug.idekey = PHPSTORM" >> /usr/local/etc/php/conf.d/20-xdebug.ini; \
    echo "xdebug.mode = off" >> /usr/local/etc/php/conf.d/20-xdebug.ini; \
    echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/20-xdebug.ini; \
    echo "xdebug.discover_client_host = 1" >> /usr/local/etc/php/conf.d/20-xdebug.ini; \
    echo "xdebug.client_host = 127.0.0.1" >> /usr/local/etc/php/conf.d/20-xdebug.ini;

# Configure bash
RUN mkdir -p /opt/bsc/bash \
 && touch /opt/bsc/bash/.bash_history

ENV HISTFILE=/opt/bsc/bash/.bash_history

# Configure user and permissions
RUN addgroup --gid 1000 application \
 && adduser --uid 1000 --gid 1000 application

RUN chown -R 1000:1000 /opt/bsc \
 && chown -R 1000:1000 /var/www
