## Prequisites

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

1. From the hot machine, navigate to the website

   ```
   http://localhost:80
   ```
