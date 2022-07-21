del %cd%\*.tar
msg %username% Zabbix containers are backing up, please dont use terminals.

docker commit zabbix-web-nginx-mysql zabbix-web-nginx-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
docker commit zabbix-server-mysql zabbix-server-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
docker commit zabbix-java-gateway zabbix-java-gateway:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
docker commit mysql-server mysql-server:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%

docker save zabbix-web-nginx-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% -o %cd%\zabbix-web-nginx-mysql.tar
docker save zabbix-server-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% -o %cd%\zabbix-server-mysql.tar
docker save zabbix-java-gateway:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% -o %cd%\zabbix-java-gateway.tar
docker save mysql-server:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% -o %cd%\mysql-server.tar

docker rmi zabbix-web-nginx-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% zabbix-server-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% zabbix-java-gateway:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% mysql-server:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%

7z a -tzip %cd%\%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%.zip %cd%\zabbix-web-nginx-mysql.tar %cd%\zabbix-server-mysql.tar %cd%\zabbix-java-gateway.tar %cd%\Zabbix\mysql-server.tar
del %cd%\*.tar

msg %username% Script completed.