pip3 install -r requirements.txt
#uwsgi --http-socket :5000 --plugin python3 -w wsgi --callable app
uwsgi --ini hello.ini --daemonize uwsgi-daemon.log
cp /var/www/app/hello.conf /etc/nginx/sites-available/hello.conf
ln -s -f /etc/nginx/sites-available/hello.conf /etc/nginx/sites-enabled/hello
service nginx restart
