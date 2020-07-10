FROM debian:8

MAINTAINER timegrid@pega.sh

ARG user=user
ARG uid=1000

RUN apt-get update && \
    apt-get install apt-utils -y

RUN adduser --disabled-password --gecos "" -u $uid $user

RUN apt-get install php5 php5-mysql git wget curl php5-curl php5-intl phpunit vim -y 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

RUN mkdir timegrid && chown $user:www-data timegrid && \
    echo "* * * * * php /var/www/timegrid/artisan schedule:run >> /dev/null 2>&1" >> /etc/crontab

USER $user

COPY --chown=$user . timegrid

WORKDIR /var/www/timegrid

RUN mkdir /tmp/timegrid_storage

RUN composer global require hirak/prestissimo && composer install --no-interaction

CMD /var/www/timegrid/entrypoint.sh

EXPOSE 8000
