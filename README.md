# Docker / PHP / nginx
This is a Dockerfile for PHP 7 with nginx, composer, nodejs


## Quick Start
```
docker pull macellantr/php-nginx:latest
```
### Running
To simply run the container:
```
docker run -d -p 8080:80 --name php-nginx macellantr/php-nginx:latest
```
Then you can hit http://localhost:8080 or http://host-ip:8080 in your browser


### Runngin with bind mount a volume
To run the container with volume:

Defualt webroot => `WEBROOT=/var/www/html`
```
docker run -d -p 8080:80 --name php-nginx -v /your/content/path:/var/www/html macellantr/php-nginx:latest
```

### Access to running container bash
Change `php-nginx` if you changed it.
```
docker exec -it php-nginx bash
```
<br /><br />
## Customize and build your image
Edit the Dockerfile or other **conf** you want then build your image
```
docker build -t macellantr/php-nginx:[YOUR_TAG] .
```


## Code Obfuscator 
Use following command to obfuscate your PHP file
```
php /opt/obfuscator/obfuscator.php YOUR_FILE_ABSOLUTE_PATH
```
