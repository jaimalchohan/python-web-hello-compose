FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y install python3
RUN apt-get -y install python3-pip

RUN apt-get -y install uwsgi-plugin-python3

RUN apt-get -y install nginx

RUN mkdir /var/www/app

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

CMD service nginx start
