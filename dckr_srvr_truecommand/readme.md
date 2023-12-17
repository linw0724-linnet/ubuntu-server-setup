# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine.

> [!NOTE]
> Skip any steps that have already been completed.

> [!NOTE]
> Please be aware that TrueCommand is free to use up to 50 total drives.
> 
> Please visit the [TrueCommand webpage](https://www.truenas.com/truecommand/) for more information on pricing above 50 drives.

> [!NOTE]
> TrueCommand is different from TrueCommand Cloud.
> 
> TrueCommand is a local self-hosted service while TrueCommand Cloud is a service hosted by iXsystems, Inc. via the cloud.

This instruction set will set up a TrueCommand inside a Docker container that can be used on your local network to manage your TrueNAS Core and TrueNAS Scale devices.

-----
# Prerequisite Setup
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/readme.md).
* [Enable Ubuntu firewall](/enable_firewall/readme.md).
* [Install SSH Server](/install_ssh-srvr/readme.md).
* Connect via PuTTY.
* Set up Ubuntu firewall for TrueCommand:
```
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```
* [Install Nano and update packages](/install_nano/readme.md).
* [Install Docker](/install_docker/readme.md).
* Create directory for TrueCommand:
```
sudo mkdir -p /opt/truecommandserver/data
```
-----
# Install TrueCommand Server
* Enter TrueCommand directory:
```
cd /opt/truecommandserver
```
* Download `docker-compose.yml` file from Github to set up the TrueCommand Docker container:
```
sudo wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/dckr_truecommand/docker-compose.yml
```
* Edit `docker-compose.yml` file:
```
sudo nano /opt/truecommandserver/docker-compose.yml
```
* Replace `<time-zone>` with the proper time zone name for your host machine.
* Save file and exit text editor.
* Test TrueCommand Docker container:
```
sudo docker-compose -f /opt/truecommandserver/docker-compose.yml config
```
* Start TrueCommand Docker container:
```
cd /opt/truecommandserver
sudo docker-compose up -d
```
* Return to root:
```
cd
```
## Installation Status Check
* Check that TrueCommand Docker container is running:
```
sudo docker ps -a
```
-----
# Using TrueCommand Server
TrueCommand is now set up in a Docker container on your host machine.

Go to the web UI for TrueCommand via a web browser under `<host-machine-IP-address>:6001` to finish setting up TrueCommand.

> [!NOTE]
> Initial username is `admin` and initial password is `admin`.
-----
# Update TrueCommand Server
* To update TrueCommand Docker container, first backup container data:
```
cp -r /opt/truecommandserver/data /opt/truecommandserver/databackup
```
* Stop TrueCommand Docker container:
```
sudo docker stop truecommand
```
* Remove old TrueCommand Docker container:
```
sudo docker rm truecommand
```
* Rebuild TrueCommand Docker container:
```
cd /opt/truecommandserver
sudo docker-compose up -d
```