> [!WARNING]
> The implementation of pulling files from Github has not yet been figured out and needs verification
# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

> [!NOTE]
> Skip any steps that have already been completed

This instruction set will set up a Plex Server inside a Docker container that has its media stored on a NAS and shared via SMB on the same network on your host machine

-----
# Instructions
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/README.md)

* [Enable Ubuntu firewall](/enable_firewall/README.md)

* [Install SSH Server](/install_ssh-server/README.md)

* Connect via PuTTY

* Set up Ubuntu firewall for Plex Server
```
sudo ufw allow 32400/tcp
```
* [Install Nano and update packages](/install_nano/README.md)

* [Install Docker](/install_docker/README.md)

* Create directories for Plex Server
```
sudo mkdir -p /nas/{database,plexserverphysicalmedia,plexservertempmedia}
sudo mkdir -p /opt/plexserver/config
```
* [Install Avahi](/install_avahi/README.md)

* [Install CIFS](/install_cifs/README.md)

* [Create CIFS credentials file](/create_cifs-credentials-file/README.md)

* Set up CIFS shares to mount at boot up
```
sudo nano /etc/fstab
```
* Add the following CIFS entries to the fstab file
> [!NOTE]
> Replace `<NAS-directory>` with the appropriate path of the SMB share on your NAS

> [!IMPORTANT]
> For the `<NAS-directory>` path to work correctly, your root directory should be suffixed with `.local`. For example, your NAS directory will look like `NAS-name.local/plexmedia`

> [!IMPORTANT]
> For the Plex Server host machine to properly access the NAS directory, ensure that permissions are set correctly in accordance with the credentials that you specified in your CIFS credentials file that you created earlier
```
# Connect Plex Database CIFS share to local Plex Server database directory
//<NAS-directory> /nas/plexserverdatabase cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
# Connect Plex Physical Media CIFS share to local Plex Server media directory
//<NAS-directory> /nas/plexserverphysicalmedia cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
# Connect Plex Temp Media CIFS share to local Plex Server media directory
//<NAS-directory> /nas/plexservertempmedia cifs uid=plexserver,credentials=/opt/plexserver/.plexservercredentials,iocharset=utf8 0 0
```
* Save file and exit text editor

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
* Enter Plex Server directory
```
cd /opt/plexserver
```
* Download `docker-compose.yml` file from Github to set up the Plex Server Docker container
```
<Needs code>
```
* Edit `docker-compose.yml` file
```
sudo nano /opt/plexserver/docker-compose.yml
```
* Replace `<insert_your_claim_token>` with the claim token given to you from `https://www.plex.tv/claim`

* Replace `<local-net/subnet>` with all your local networks separated by commas, it should look something like `10.0.0.1/24,10.0.0.2/24,10.0.0.3/24`

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
* Enter Plex Server directory
```
cd /opt/plexserver
```
* Download `plexserver_cifs_check.sh` file from Github
> [!NOTE]
> This script will automatically check the status of your CIFS shares and auto remount if necessary
```
<Needs code>
```
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
-----
#Conclusion
Plex Server is now set up in a Docker container on your host machine

Go to the web UI for plex via a web browser under `https://app.plex.tv/desktop/` to finish setting up your Plex Server
