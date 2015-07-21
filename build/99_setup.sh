#!/usr/bin/env sh

/bin/cp /webserver/conf/php/cli/php.ini /etc/php5/cli/php.ini
/bin/cp /webserver/conf/php/php-fpm/php.ini /etc/php5/fpm/php.ini

/bin/cp /webserver/conf/nginx/*.crt /etc/nginx/ssl/
/bin/cp /webserver/conf/nginx/*.key /etc/nginx/ssl/

/bin/cp /webserver/conf/php/php-fpm/php-fpm.conf /etc/php5/fpm/php-fpm.conf
/bin/cp /webserver/conf/php/php-fpm/www.conf /etc/php5/fpm/pool.d/www.conf

/usr/bin/crontab -u www-data /webserver/conf/cron/crontab

/usr/sbin/nginx

/usr/sbin/php5-fpm --daemonize --fpm-config /etc/php5/fpm/php-fpm.conf
