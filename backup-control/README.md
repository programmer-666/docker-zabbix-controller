# Backup Controller

The scripts here are actually an automated series of sequential processes. Different codes can be used for nt and *nix, but in essence the operations are the same.

## Backup Operation
The containers to be backed up are first converted to images and then exported as tar. To return from the backup, the `load` command is used. The commands during installation are used for restored images.

### Commit
Create a new image from the running container.
Example:
```sh
docker commit mycontainer mycontainer:v1
```
> If you want, you can also annotate your commits using the `-m` parameter.

### Save
You can export the backup images you created as tar with the `save` command.
```sh
docker save mycontainer:v1 -o mycontainer.tar
```

## Backup Script
In this section, we will examine a script that automates the processes I mentioned above and compresses the _TAR_ (backup) files  that we have obtained and collects them under a single file.

### Windows
You can automate image creation and backup processes using `bat` on windows.
#### Directory Clean Up
It is important that there are no other tar files in the folder where the script will run. The commands here delete the tar files in the directory where the script is located and provide information about the script.
```cmd
del %cd%\*.tar
msg %username% Zabbix containers are backing up, please dont use terminals.
```
> Replace `cd` with the directory where the backups are located.

#### Commit&Save
First commit operations and then save operations are done respectively. You can specify a custom name for the backup images. In the example here, the names of the four containers zabbix is running are used exactly.

> The tag used in the examples `V1B%DATE:~10.4%%DATE:~4.2%%DATE:~7.2%` indicates that the image is a backup and the current date. 

```sh
docker commit zabbix-web-nginx-mysql zabbix-web-nginx-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
docker commit zabbix-server-mysql zabbix-server-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
docker commit zabbix-java-gateway zabbix-java-gateway:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
docker commit mysql-server mysql-server:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%

docker save zabbix-web-nginx-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% -o %cd%\zabbix-web-nginx-mysql.tar
docker save zabbix-server-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% -o %cd%\zabbix-server-mysql.tar
docker save zabbix-java-gateway:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% -o %cd%\zabbix-java-gateway.tar
docker save mysql-server:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% -o %cd%\mysql-server.tar
```

#### Cleaning Backup Images From Docker
If the backup images are not removed from the docker service, they will take up unnecessary space. The `rmi` command can be used to clean backup images.

```sh
docker rmi zabbix-web-nginx-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% \
zabbix-server-mysql:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% \
zabbix-java-gateway:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2% \
mysql-server:V1B%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
```

#### Compressing & Final
The script compresses all the backups in the folder. Alternatives can be used for compression. In this example, a compression was made in *zip* format using the *7z* program.

```sh
7z a -tzip %cd%\%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%.zip \
%cd%\zabbix-web-nginx-mysql.tar \
%cd%\zabbix-server-mysql.tar \
%cd%\zabbix-java-gateway.tar \
%cd%\Zabbix\mysql-server.tar
```

Finally, all tar files in the folder are deleted and the script displays a `messagebox` that is complete.

```cmd
del %cd%\*.tar
msg %username% Script completed.
```
