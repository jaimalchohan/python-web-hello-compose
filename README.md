## Prerequisites

1. Docker (solution was built using Docker for Mac Version 1.12.0)

## How to run it

1. Build the Docker image

   ```
   cd ~/Github/python-web-hello
   docker build -t python-web-hello .
   ```

1. Run the Docker container

   ```
   docker run -d -p 80:5000 -v ~/Github/python-web-hello:/var/www/app --name python-web-hello-container python-web-hello
   ```

1. SSH into the container and run the startup script

   ```
   docker attach python-web-hello-container
   cd /var/www/app
   sh start.sh
   ```

1. Exit the container (without stopping it)

   ```
   crtl+p, crtl+q
   ```

1. From the host machine, navigate to the website

   ```
   http://localhost:80
   ```

## How it works

1. The Python application

   The python application consists of 2 files.
   1. [hello.py](/hello.py): This is the actual code of the application
   2. [requirements.txt](/requirements.txt): This defines the modules required by the application

   The application is built for Python 3 and uses the [Flask](http://flask.pocoo.org/) micro web framework.

   If you wanted to run this natively (without docker and all the jazz, just as a python app) then you can run the following commands.  
   ```
   pip install -r requirements.txt
   python hello.py
   ```
   _Depending on how Python is bound you may need to use `pip3` and `python3` instead._

   The site is hosted by a tiny HTTP server that ships with Flask.  It's great for development, but not so great for actual production hosting.

2. Web Server Gateway Interface (WSGI)

   [Web Server Gateway Interface](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface) is a specfiication for how Web Servers should communication with Python Web Applications. It's similar to CGI, FastCGI and mod_python.  Esentially it's a specficiation for how to translate a HTTP request into something that the Python application can understand.

   Flask does ship with its own wsgi server, but it's rudimentary and doesn't handle things like scaling.

   There are a few WSGI servers to choose from; I chose [uWSGI](https://github.com/unbit/uwsgi) becuase it seemed popular.

   The uWSGI configuration consists of 2 files
   1. [wsgi.py](/wsgi.py): This is the python needed by uWSGI ti start the Flash application. It imports the `app` from the the `hello.py` application file
   2. hello.ini: This is the uWSGI ini file containing the configuration options needed to run the server

3.
