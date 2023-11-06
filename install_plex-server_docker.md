* Skip any steps that have already been completed<br>
* Fix 'A start job is running, wait for network to be configured' on bootup<br>
* [Enable Ubuntu firewall](enable_ubuntu-firewall.md)<br>
* [Install SSH Server](install_ssh-server.md)<br>
* Connect via PuTTY<br>
* Set up Ubuntu firewall for Plex Server<br>
```
sudo ufw allow 32400/tcp
```
* Install Nano and update packages<br>
* Install Docker<br>
* Create directories for Plex Server<br>
```
sudo mkdir -p /nas/{database,plexserverphysicalmedia,plexservertempmedia}
sudo mkdir -p /opt/plexserver/config
```
* Install Avahi<br>
* Install CIFS<br>
* Create CIFS credentials file<br>
* Set up CIFS shares to mount at boot up<br>
```
sudo nano /etc/fstab
```
* Add the following CIFS entries to the fstab file
```
# Connect Plex Database CIFS share to local Plex Server database directory
//<NAS-name>.local/<nas-database-directory> /nas/plexserverdatabase cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
# Connect Plex Physical Media CIFS share to local Plex Server media directory
//<NAS-name>.local/<nas-physical-media-directory> /nas/plexserverphysicalmedia cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
# Connect Plex Temp Media CIFS share to local Plex Server media directory
//<NAS-name>.local/<nas-temp-media-directory> /nas/plexservertempmedia cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
```
* Save file and exit text editor<br>
* Mount CIFS shares
```
sudo mount -a
```
* Check if Plex Server physical media CIFS shares are visible
```
cd /nas/plexserverphysicalmedia
ls -a
```
* Return to root
```
cd
```
* Check if Plex Server temp media CIFS shares are visible
```
cd /nas/plexservertempmedia
ls -a
```
* Return to root
```
cd
```
* Check if Plex Server database CIFS shares are visible
```
cd /nas/plexserverdatabase
ls -a
```
* Return to root
```
cd
```
* Configure Plex Docker container
```
sudo nano /opt/plexserver/docker-compose.yml
```
* Enter configuration for Plex Docker container into compose file
```
version: "3.9"
services:
  plex:
    container_name: plexserver
    image: plexinc/pms-docker:public
    restart: unless-stopped
    # Configure the network mode for Plex
    network_mode: host
    environment:
      - TZ=America/Los_Angeles
      # Token from https://www.plex.tv/claim
      - PLEX_CLAIM=<insert_your_claim_token>
      # Internal networks for Plex
      - ALLOWED_NETWORKS=<network/subnet separated by commas>
    volumes:
      # The format is <host_path>:<container_path>
      # Path to where the Plex configuration/database files will be stored
      - /plexserver/config:/config
      # Path to where the Plex database backup files will be stored
      - /nas/plexserverdatabase:/database
      # Path to local Plex Server physical media directory
      - /nas/plexserverphysicalmedia:/physicalmedia
      # Path to local Plex Server temp media directory
      - /nas/plexservertempmedia:/tempmedia
```
* Save file and exit text editor<br>
* Test Plex Docker container
```
sudo docker-compose -f /opt/plexserver/docker-compose.yml config
```
* Start Plex Docker container
```
cd /opt/plexserver
sudo docker-compose up -d
```
* Return to root
```
cd
```
* Creating Plex Server Database CIFS Check Script to monitor CIFS connections
```
sudo nano /opt/plexserver/plexserver_cifs_check.sh
```
* Add the following lines to the Plex Server Database CIFS Check Script for CIFS mount checking
```
#!/bin/bash
# Checks if Plex CIFS shares are mounted to local corresponding Plex Server directories
if [[ mountpoint -q /nas/plexserverdatabase || mountpoint -q /nas/plexserverphysicalmedia || mountpoint -q /nas/plexservertempmedia ]]
  # If Plex CIFS shares are mounted to local corresponding Plex Server directories, do nothing
  then
    :
  # If Plex Database CIFS share are not mounted to local corresponding Plex Server directories, remount shares and restart Plex container
  else
    sudo mount -a; sudo docker restart plexserver
fi
```
* Save file and exit text editor<br>
* Give Plex Server Database CIFS Check Script execute permissions
```
sudo chmod 555 /opt/plexserver/plexserver_cifs_check.sh
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
# Set Plex Server CIFS Check Script to run at reboot
@reboot /opt/plexserver/plexserver_cifs_check.sh
# Set Plex Server CIFS Check Script to run every 1 minute
*/1 * * * * /opt/plexserver/plexserver_cifs_check.sh
# Set Plex Docker container to auto update and restart daily at 0500
0 5 * * * docker restart plexserver
```
* Save file and exit text editor
* Plex Server is now set up in a Docker container, go to the web UI via a web browser to finish setting up your server
