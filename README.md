# docker-facturascripts with xdebug and phpmyadmin

FacturaScripts unofficial Docker image.
Forked from the official FacturaScripts/docker-facturascripts

This version:
- adds **xdebug** to facturascripts image
- adds **phpmyadmin** image to docker-compose stack (using port 9980)
- uses port 8880 instead of 80 for image facturascripts
- uses port 8306 instead of 3306 for image mysql
- renames image names (mysql, facturascripts) to (altmysql, altfacturascripts)
- gets from dockerhub my image `jstnl/facturascripts-xdebug` instead of `facturascripts/facturascripts`
- modifies Dockerfile and docker-compose.yml to achieve the previous points

https://hub.docker.com/r/jstnl/facturascripts-xdebug

&nbsp;

## Remote php debugging with docker, Netbeans and xdebug

php.ini settings:
```
[xdebug]
zend_extension=xdebug.so
xdebug.profiler_enable=1
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_host=host.docker.internal
# host.docker.internal is a "magic" hostname in docker to reach the host
xdebug.remote_port=9000
xdebug.remote_autostart=1
xdebug.remote_connect_back=1
xdebug.idekey=netbeans-xdebug
```

Replace host.docker.internal with the hostname or ip of the webserver if in your case it is a different machine.

With this settings there is no need to start the debugging session "manually", so:
- Disable opening the web browser in IDE. In Netbeans -> project properties -> run configuration -> advanced -> choose "Do not open web browser" for "debug url"
- No need to have installed the "Xdebug helper" extension (or similar extensions) in chromium based browsers, no need for any extension in any browser. You can use any (modern) browser to debug.

My understanding is with every request to the webserver xdebug checks if the IDE is listening on port 9000 and then connects and start the debugging session. IDE will be listening only if we manually use the debug features of the IDE.

Netbeans settings:
- menu tools -> options -> php -> debugging
	 debugger port: 9000 (default)
	 session id: netbeans-xdebug (default)
	 uncheck all following checkboxes

- project properties -> run configuration -> advanced -> path mapping
	Here we have to tell Netbeans the correspondence between location of php files in the server and in the project folder. Important: use absolute paths.\
	Example (2 rows, first for my plugin, second for FS core):
			
	|server path|project path|
	|---|---|
	|/var/www/html/Plugins/MiPlugin|/home/myusername/gits/MiPlugin|
	|/var/www/html/|/home/myusername/dockerstacks/fswithxdebug/facturascripts|

&nbsp;

## Phpmyadmin

Customizations:

- Displays the field to enter the server to connect to. Useful to be able to connect to other mysql/mariadb servers (in the LAN or in the internet) using the latest version of phpmyadmin.\
Achieved via docker-compose environment variable `PMA_ARBITRARY=1` 

- Increases the file upload limit to 300 MB approx\
Achieved via docker-compose environment variable `UPLOAD_LIMIT=300000000` 

- Increases the session timeout from 24 minutes to one week\
Achieved via file config.user.inc.php :
```php
// increase session timeout
$sessionDuration = 60*60*24*7; // 60*60*24*7 = one week, default was 1440
ini_set('session.gc_maxlifetime', $sessionDuration);
$cfg['LoginCookieValidity'] = $sessionDuration;
```

- Increases the maximum execution time\
Achieved via file config.user.inc.php :
```php
// increase the maximum execution time
$cfg['ExecTimeLimit'] = 3000; // default = 300 s = 5 min, increased to 50 min.
```
