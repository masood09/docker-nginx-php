# Use phusion/baseimage as base image.
FROM phusion/baseimage:0.9.15

# Set correct environment variables.
ENV HOME /root

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Regenerate SSH host keys. baseimage-docker does not contain any, so we
# have to do that yourself.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Gerenare the locales
RUN locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8

# Add the required repositories
RUN apt-get install apt-transport-https
RUN add-apt-repository -y ppa:ondrej/php5-5.6
RUN apt-add-repository -y ppa:nginx/stable
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 4F4EA0AAE5267A6C

# Update & upgrade the repositories
RUN apt-get update
RUN apt-get -y --force-yes upgrade

# Install PHP5 (5.6.11)
RUN apt-get install -y --force-yes php5-cli php5-dev php5-mysqlnd php5-curl php5-gd php5-gmp php5-mcrypt php5-redis php5-xdebug php5-xmlrpc libwebp-dev git php5-intl

# Install Nginx (1.8.0) and PHP-FPM
RUN apt-get install -y --force-yes nginx php5-fpm

# Install composer
RUN mkdir -pv /usr/local/bin; cd /tmp; curl -sS https://getcomposer.org/installer | php; mv composer.phar /usr/local/bin/composer; chmod +x /usr/local/bin/composer

# Create the SSL directories
RUN mkdir -p /etc/nginx/ssl

# Copy the init files for webserver
ADD build/99_setup.sh /etc/my_init.d/99_setup.sh
RUN chmod +x /etc/my_init.d/99_setup.sh

# Make the port 80 and 443 available to outside world
EXPOSE 80
EXPOSE 443

# Clean doc and man files.
RUN find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true
RUN find /usr/share/doc -empty|xargs rmdir || true
RUN rm -rf /usr/share/man /usr/share/groff /usr/share/info /usr/share/lintian > /usr/share/linda /var/cache/man

# Clean up APT when done.
RUN apt-get clean
RUN apt-get autoclean
RUN apt-get autoremove
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
