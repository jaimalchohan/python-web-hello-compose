FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y install python3
RUN apt-get -y install python3-pip
RUN apt-get -y install uwsgi-plugin-python3

EXPOSE 5000

WORKDIR /app

CMD pip3 install -r requirements.txt && uwsgi --ini hello.ini
