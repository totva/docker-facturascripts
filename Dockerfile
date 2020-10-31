FROM php:7.4-apache

# Install dependencies
RUN apt-get update && \
	apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libpq-dev libzip-dev unzip && \
	apt-get clean && \
	a2enmod rewrite && \
	service apache2 restart && \
	docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
	docker-php-ext-install bcmath gd mysqli pdo pdo_mysql pgsql zip && \
	php-dev autoconf automake

# previous line needed to compile php extensions (needed to instal xdebug)

ENV FS_VERSION 2020.71

# Download FacturaScripts
ADD https://facturascripts.com/DownloadBuild/1/${FS_VERSION} /tmp/facturascripts.zip

# Unzip
RUN unzip -q /tmp/facturascripts.zip -d /usr/src/; \
	rm -rf /tmp/facturascripts.zip

VOLUME /var/www/html

COPY facturascripts.sh /usr/local/bin/facturascripts
RUN chmod +x /usr/local/bin/facturascripts

# download, extract and install xdebug
ADD http://xdebug.org/files/xdebug-2.9.8.tgz /tmp/xdebug-x.y.z.tgz
RUN tar -xvzf /tmp/xdebug-x.y.z.tgz
RUN cd xdebug-x.y.z
RUN phpize
RUN ./configure
RUN make
RUN cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902
RUN echo "\nzend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so" >> /usr/local/etc/php/php.ini
RUN /etc/init.d/apache2 restart

CMD ["facturascripts"]
