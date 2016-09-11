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

### The Python application

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

### Web Server Gateway Interface (WSGI)

[Web Server Gateway Interface](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface) is a specfiication for how Web Servers should communication with Python Web Applications. It's similar to CGI, FastCGI and mod_python.  Esentially it's a specficiation for how to translate a HTTP request into something that the Python application can understand.

Flask does ship with its own wsgi server, but it's rudimentary and doesn't handle things like scaling.

There are a few WSGI servers to choose from; I chose [uWSGI](https://github.com/unbit/uwsgi) becuase it seemed popular.

The uWSGI configuration consists of 2 files

1. [wsgi.py](/wsgi.py): This is the python needed by uWSGI ti start the Flash application. It imports the `app` from the the `hello.py` application file
2. [hello.ini](/hello.ini): This is the uWSGI ini file containing the configuration options needed to run the server when using a webserver (like Apache or NGINX)

You can test the application runs under uWSGI by running:
```
uwsgi --http-socket :5000 --plugin python3 -w wsgi --callable app
```
This won't use the [hello.ini](hello.ini) file but will prove that the application runs in the uWSGI server over http.

#### WSGI in production   

In a production environment you could just use uWSGI as the webserver, however often this is isn't usually very scaleable.  

uWSGI acts as a host for the Python application, and forwards all requests onto the application, however often there are static files you don't need to be served from the expensive Python process.  Caching, throttling and authentication are other concerns separate webserver applications specialise in.

The [hello.ini](/hello.ini) contains some additional options for running in production

- `master = true`: run a master uWSGI process which can handle the spawning of child processes.  This means you can run several Python processes to handle requests and send any commands to all processes via the master.
- `socket = hello.sock`: unix based systems can use binary sockets to communicate with each other using binary transport.  This is faster than any other method of transport. We want the NGINX process to communicate with the uWSGI process using a socket.
- `vacuum = true`: delete the socket when the uWSGI process is stopped

### NGINX

[NGINX](https://www.nginx.com) is a high performance HTTP server. We're going to use [NGINX](https://www.nginx.com) to handle out HTTP traffic, and pass on Requests to the Python application that is hosted in uWSGI.  

[NGINX](https://www.nginx.com) ships with WSGI support enabled by default, so all we need to do is provide some configuration.  The NGINX configuration consists of 1 file

1. [hello.conf](/hello.conf): This contains some configuration that causes NGINX to
  1. Listen to port 5000 on the `defualt_server` (127.0.0.1)
  2. For all Requests with the location `/` (which will match all Requests) forward the traffic via wsgi onto the socket, which we defined in [hello.ini](/hello.ini)
