# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

> [!NOTE]
> Skip any steps that have already been completed

This instruction set will set up a Deluge Server inside a Docker container that has its downloads stored on a NAS and shared via SMB on the same network on your host machine

-----
# Instructions
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/README.md)

* [Enable Ubuntu firewall](/enable_firewall/README.md)

* [Install SSH Server](/install_ssh-server/README.md)

* Connect via PuTTY

* Set up Ubuntu firewall for Deluge Server
```
sudo ufw allow 6881
sudo ufw allow 6881/udp
sudo ufw allow 8112
sudo ufw allow 8113
sudo ufw allow 58846
sudo ufw allow 58847
```
* [Install Nano and update packages](/install_nano/README.md)

* [Install Docker](/install_docker/README.md)

* Create directories for Deluge Server
```
sudo mkdir -p /nas/delugeserverdownloads
sudo mkdir -p /opt/delugeserver/config
```
* [Install Avahi](/install_avahi/README.md)

* [Install CIFS](/install_cifs/README.md)

* Enter Deluge Server directory
```
cd /opt/delugeserver
```
* Download `.delugeservercredentials` file from Github in preparation for mounting CIFS shares to the host machine
```
wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/install_docker-container_deluge-server/.delugeservercredentials
```
* Edit `.delugeservercredentials` file
```
sudo nano /opt/delugeserver/docker-compose.yml
```
* Replace `<username>` and `<passowrd>` with the proper credentials for accessing the CIFS shares on the NAS

* Save file and exit text editor

* Set up CIFS shares to mount at boot up
```
sudo nano /etc/fstab
```
* Add the following CIFS entries to the fstab file
> [!NOTE]
> Replace `<NAS-share-path>` with the appropriate path of the SMB share on your NAS

> [!NOTE]
> On the NAS, it is recommended that you put all directories needed by the Deluge server in the same dataset to prevent the Deluge server from taking a long time when moving files in between directories. Having all directories within the same NAS dataset will allow the file movements to be a folder move within the NAS share rather than a transfer over the network between NAS datasets

> [!IMPORTANT]
> For the `<NAS-share-path>` path to work correctly, your root directory should be suffixed with `.local`. For example, your NAS directory will look like `<NAS-name>.local/<directory>`

> [!IMPORTANT]
> For the Deluge Server host machine to properly access the NAS directory, ensure that directory permissions on the NAS are set correctly in accordance with the credentials that you specified in your CIFS credentials file that you created earlier
```
# Connect Torrents CIFS share to local Deluge Server downloads directory
//<NAS-share-path> /nas/delugeserverdownloads cifs uid=1000,credentials=/opt/delugeserver/.delugeservercredentials,iocharset=utf8 0 0
```
* Save file and exit text editor

* Mount CIFS shares
```
sudo mount -a
```
* Check if Torrents CIFS shares are visible
```
cd /nas/delugeserverdownloads
ls -a
```
* Return to root
```
cd
```
* Enter Deluge Server directory
```
cd /opt/delugeserver
```
* Download `docker-compose.yml` file from Github to set up the Deluge Server Docker container
```
wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/install_docker-container_deluge-server/docker-compose.yml
```
* Edit `docker-compose.yml` file
```
sudo nano /opt/delugeserver/docker-compose.yml
```
* Replace `<time-zone>` with the proper time zone name for your host machine

* Save file and exit text editor

* Test Deluge Docker container
```
sudo docker-compose -f /opt/delugeserver/docker-compose.yml config
```
* Return to root
```
cd
```
* Start Deluge Docker container
```
cd /opt/delugeserver
sudo docker-compose up -d
```
* Return to root
```
cd
```
* Enter Deluge Server directory
```
cd /opt/delugeserver
```
* Download `delugeserver_cifs_check.sh` file from Github
> [!NOTE]
> This script will automatically check the status of your CIFS shares and auto remount if necessary
```
wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/install_docker-container_deluge-server/delugeserver_cifs_check.sh
```
* Give Deluge Server CIFS Check Script execute permissions
```
sudo chmod 555 /opt/delugeserver/delugeserver_cifs_check.sh
```
* Return to root
```
cd
```
* Set startup scripts
```
crontab -e
```
* Add the following entries to the crontab file
```
# Set Deluge Server CIFS Check Script to run at reboot
@reboot /opt/delugeserver/delugeserver_cifs_check.sh
# Set Deluge Server CIFS Check Script to run weekly on Monday at 0500
0 5 * * 1 /opt/delugeserver/delugeserver_cifs_check.sh
# Set Deluge Docker container to auto update and restart weekly on Monday at 0500
0 5 * * 1 docker restart delugeserver
```
* Save file and exit text editor

* Bash into Deluge Docker container
```
sudo docker exec -it delugeserver /bin/bash
```
* Enter authorization file
```
cd config
vi auth
```
* Add entries to the authorization file for each user
```
<username>:<password>:10
```
* Save file and exit text editor

* On client computer, open Deluge and connect through the Connection Manager
-----
# Conclusion
Deluge Server is now set up in a Docker container on your host machine

Go to the web UI for Deluge via a web browser under `<host-machine-IP-address>:<port>` to finish setting up your Deluge Server
