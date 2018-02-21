FROM ubuntu:latest

MAINTAINER Jorge Lopez <jorge.lopez@dreams.es>

# Compilar con: docker build . -t repositorio/apache-php:7.1

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN apt-get -y update

RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update -y

RUN apt-get install -y vim
RUN apt-get install -y curl
RUN apt-get install -y mysql-client

RUN apt-get install -y \
  libfreetype6-dev \
  libmcrypt-dev \
  libpng12-dev \
  libxml2-dev \
  libcurl4-gnutls-dev

RUN apt-get -y install apache2 \
	libapache2-mod-php7.1

RUN apt-get purge -y php
RUN apt-get purge -y php7.2

RUN apt-get -y install php7.1 \
	php7.1-common \
	php7.1-soap \
	php7.1-mcrypt \
	php7.1-mbstring \
	php7.1-curl \
	php7.1-cli \
	php7.1-mysql \
	php7.1-gd \
	php7.1-intl \
	php7.1-xsl \
	php7.1-xml \
	php7.1-zip \
	php7.1-bcmath \
	php7.1-mysql \
	php7.1-mysql


RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

RUN /usr/sbin/a2enmod rewrite
RUN /usr/sbin/a2enmod headers

RUN  sed -i 's/\/html/\/html\/wordpress/g' /etc/apache2/sites-available/000-default.conf

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

WORKDIR /var/www/html/wordpress/

EXPOSE 80

#CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

CMD ["/usr/local/bin/start.sh"]