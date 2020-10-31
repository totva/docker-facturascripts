# docker-facturascripts with xdebug and phpmyadmin

FacturaScripts unofficial Docker image.
Forked from the official FacturaScripts/docker-facturascripts

This version:
- adds **xdebug** to facturascripts image
- adds **phpmyadmin** image to docker-compose stack (using port 9980)
- uses port 8880 instead of 80 for image facturascripts
- uses port 8306 instead of 3306 for image mysql
- renames image names (mysql, facturascripts) to (altmysql, altfacturascripts)
- modifies Dockerfile and docker-compose.yml to achieve the previous points


&nbsp;