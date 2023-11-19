# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

> [!NOTE]
> Skip any steps that have already been completed

> [!NOTE]
> Please be aware that TrueCommand is free to use up to 50 total drives
> 
> Please visit the [TrueCommand webpage](https://www.truenas.com/truecommand/) for more information on pricing above 50 drives

> [!NOTE]
> TrueCommand is different from TrueCommand Cloud
> 
> TrueCommand is a local self-hosted service while TrueCommand Cloud is a service hosted by iXsystems, Inc. via the cloud

This instruction set will set up a TrueCommand inside a Docker container that can be used on your local network to manage your TrueNAS Core and TrueNAS Scale devices

-----
# Instructions
## Installing TrueCommand
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/README.md)

* [Enable Ubuntu firewall](/enable_firewall/README.md)

* [Install SSH Server](/install_ssh-server/README.md)

* Connect via PuTTY

* Set up Ubuntu firewall for TrueCommand
```
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```
* [Install Nano and update packages](/install_nano/README.md)

* [Install Docker](/install_docker/README.md)

* Create directory for TrueCommand
```
sudo mkdir -p /opt/truecommand/data
```
* Enter TrueCommand directory
```
cd /opt/truecommand
```
* Download `docker-compose.yml` file from Github to set up the TrueCommand Docker container
```
sudo wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/dckr_TrueCommand/docker-compose.yml
```
* Edit `docker-compose.yml` file
```
sudo nano /opt/truecommand/docker-compose.yml
```
* Replace `<time-zone>` with the proper time zone name for your host machine

* Save file and exit text editor

* Test TrueCommand Docker container
```
sudo docker-compose -f /opt/truecommand/docker-compose.yml config
```
* Start TrueCommand Docker container
```
cd /opt/truecommand
sudo docker-compose up -d
```
* Return to root
```
cd
```
* Check that TrueCommand Docker container is running
```
sudo docker ps -a
```
* Go to on another machine and access `https://<IP-of-host-running-TrueCommand>:80` on a web browser to access TrueCommand

* Initial username is `admin` and initial password is `admin`
## Updating TrueCommand
* To update TrueCommand Docker container, first backup container data
```
cp -r /opt/truecommand/data /opt/truecommand/databackup
```
* Stop TrueCommand Docker container
```
sudo docker stop truecommand
```
* Remove old TrueCommand Docker container
```
sudo docker rm truecommand
```
* Rebuild TrueCommand Docker container
```
cd /opt/truecommand
sudo docker-compose up -d
```
* Check that TrueCommand Docker container is running
```
sudo docker ps -a
```
-----
# Conclusion
TrueCommand is now set up in a Docker container on your host machine

You can now configure your local TrueNAS machines with TrueCommand
