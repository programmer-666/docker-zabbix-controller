# Installation Steps
The images used in the steps can be changed. Old or current versions or backup images can be used.
## Creating Network
Set up a network where containers can communicate with each other.
Example:
```sh
docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 zabbix-net
```

## Installing MySQL Server
Edit environment variables before installation. Make sure you take image you need.
```sh
docker run --name mysql-server -t \
-e MYSQL_DATABASE="zabbix" \
-e MYSQL_USER="zabbix" \
-e MYSQL_PASSWORD="zabbix_pwd" \
-e MYSQL_ROOT_PASSWORD="root_pwd" \
--network=zabbix-net -d mysql:8.0 \
--character-set-server=utf8 --collation-server=utf8_bin --default-authentication-plugin=mysql_native_password
```

## Java Gateway & Zabbix Server (MySQL)
### Java Gateway
```sh
docker run --name zabbix-java-gateway -t  \
--network=zabbix-net  \
--restart unless-stopped -d \
zabbix/zabbix-java-gateway:alpine-6.2-latest
```
### Zabbix Server
The environment variable information entered for the containers must be the same.
```sh
docker run --name zabbix-server-mysql -t \
-e DB_SERVER_HOST="mysql-server" \
-e MYSQL_DATABASE="zabbix" \
-e MYSQL_USER="zabbix" \
-e MYSQL_PASSWORD="zabbix_pwd" \
-e MYSQL_ROOT_PASSWORD="root_pwd" \
-e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
--network=zabbix-net -p 10051:10051 \
--restart unless-stopped -d zabbix/zabbix-server-mysql:alpine-6.2-latest
```
> A special IP can be assigned by adding `:<IP>` to the network parameter.
> Example:
> `--network=zabbix-net:172.20.240.1`

## Nginx Web Interface
```sh
docker run --name zabbix-web-nginx-mysql -t \
-e ZBX_SERVER_HOST="zabbix-server-mysql" \
-e DB_SERVER_HOST="mysql-server" \
-e MYSQL_DATABASE="zabbix" \
-e MYSQL_USER="zabbix" \
-e MYSQL_PASSWORD="zabbix_pwd" \
-e MYSQL_ROOT_PASSWORD="root_pwd" \
--network=zabbix-net -p 80:8080 \
--restart unless-stopped -d zabbix/zabbix-web-nginx-mysql:alpine-6.2-latest
```

# _Conclusion_

If you have successfully followed the steps, you will have four working containers.
```sh
CONTAINER ID   IMAGE                                          COMMAND                  CREATED             STATUS             PORTS                            NAMES
77bf719d346d   zabbix-web-nginx-mysql:v1                      "docker-entrypoint.sh"   About an hour ago   Up About an hour   8443/tcp, 0.0.0.0:80->8080/tcp   zabbix-web-nginx-mysql
5e43cd92f258   zabbix/zabbix-server-mysql:alpine-6.2-latest   "/sbin/tini -- /usr/…"   2 days ago          Up 5 hours         0.0.0.0:10051->10051/tcp         zabbix-server-mysql
d6703e13cc48   zabbix/zabbix-java-gateway:alpine-6.2-latest   "docker-entrypoint.s…"   2 days ago          Up 5 hours         10052/tcp                        zabbix-java-gateway
e8f5c37474da   mysql:8.0                                      "docker-entrypoint.s…"   2 days ago          Up 2 hours         3306/tcp, 33060/tcp              mysql-server
```