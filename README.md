## Prerequisites

This is a continuation of my [python-web-hello](https://github.com/jaimalchohan/python-web-hello) sample application.
This will only really make sense if you have at least read the README for that.

## How to run it

1. Build the Flask and NGINX image

   ```
   cd ~/Github/python-web-hello-compose
   docker-compose build .
   ```

1. Run the Flask and NGINX containers

   ```
   docker-compose up
   ```

## Docker Compose

What I've done is to split the uWSGI server (which is hosting the Flask application) from the NGINX server. A good practice for Docker containers is for them to have separate roles.  In my previous example 1 server performed both roles, now we have 2 severs each performing it's own role.

I've used docker compose which allows me to specify my build and run configuration in a .yml file and use the docker-compose command to launch them.

In the process of splitting apart the Flask and NGINX server, I was able to reduce the amount of customisation I needed and totally removed the start.sh script.  This is by far a better solution.
