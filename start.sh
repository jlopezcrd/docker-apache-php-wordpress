#!/bin/bash

WORDPRESS_SHA1=$(curl -s https://wordpress.org/wordpress-$WORDPRESS_VERSION.tar.gz.sha1)
WORDPRESS_SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

if [ -d "/var/www/html/wordpress/" ]; then

	if [ ! $(ls -A "/var/www/html/wordpress/" | head -n 1) ]; then

		curl -o wordpress.tar.gz -fSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz"; \
		echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c -; \

		tar -xzf wordpress.tar.gz -C /var/www/html/; \
		rm wordpress.tar.gz; \

		if [ $? -ne 0 ]; then
			echo " "
			echo " "
			echo "==================="
			echo "¡ DEPLOY ERRONEO !"
			echo "==================="
			echo " "
			echo " "
			exit;
		fi

		# Datos de conexion
		cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
		sed -i 's/localhost/'$WORDPRESS_DB_HOST'/g' /var/www/html/wordpress/wp-config.php
		sed -i 's/database_name_here/'$WORDPRESS_DB_NAME'/g' /var/www/html/wordpress/wp-config.php
		sed -i 's/username_here/'$WORDPRESS_DB_USER'/g' /var/www/html/wordpress/wp-config.php
		sed -i 's/password_here/'$WORDPRESS_DB_PASSWORD'/g' /var/www/html/wordpress/wp-config.php

		# CAMBIAR prefix _wp
		sed -i "s/$table_prefix  = 'wp_'/$table_prefix  = '"$WORDPRESS_PREFIX"'/g" /var/www/html/wordpress/wp-config.php

		# Salt Random
		while read -r $SALT; do
		SEARCH="define('$(echo "$SALT" | cut -d "'" -f 2)"
		REPLACE=$(echo "$SALT" | cut -d "'" -f 4)
		sed -i "/^$SEARCH/s/put your unique phrase here/$(echo $REPLACE | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g')/" /var/www/html/wordpress/wp-config.php
		done <<< "$WORDPRESS_SALT"

		# CONFIGURAR WP_DEBUG
		sed -i "s/define('WP_DEBUG', false)/define('WP_DEBUG', "$WORDPRESS_DEBUG")/g" /var/www/html/wordpress/wp-config.php

		chown -R www-data:www-data /var/www/html/wordpress

		echo " "
		echo " "
		echo "==================="
		echo "¡ DEPLOY CORRECTO !"
		echo "==================="
		echo " "
		echo " "

	fi

fi

echo "INICIANDO SERVICIO WEB..."
/usr/sbin/apache2ctl -D FOREGROUND