FROM php:7.3-fpm

RUN apt-get update && apt-get -y install \
  unzip \
  sendmail \
  libpng-dev \
  libzip-dev \
  nano \
  zlib1g-dev \
  git \
  npm \
  git \
  && docker-php-ext-install mysqli pdo_mysql \
  && docker-php-ext-enable mysqli \
  && docker-php-ext-install mbstring \
  && docker-php-ext-install zip \
  && docker-php-ext-install gd
  

# Installing node
ENV NODE_VERSION=16.13.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# installing composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN composer require setasign/fpdi \ 
&& composer require "ext-gd:*" --ignore-platform-reqs \
&& composer require mpdf/mpdf "^v8.0.7"

EXPOSE 9000
CMD ["/usr/local/sbin/php-fpm"]