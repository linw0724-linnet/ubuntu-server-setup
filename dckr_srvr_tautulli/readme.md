# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine.

> [!NOTE]
> This instruction set assumes that you have already successfully completed an install of Plex Media Server on your host machine following the [directions](/dckr_srvr_plex/readme.md) in this repository.

> [!NOTE]
> Skip any steps that have already been completed.

This instruction set will set up a Tautulli Server inside a Docker container to monitor Plex Media Server activity and track statistics.

-----
# Prerequisite Setup
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/readme.md).
* [Enable Ubuntu firewall](/enable_firewall/readme.md).
* [Install SSH Server](/install_ssh-srvr/readme.md).
* Connect via PuTTY.
* Set up Ubuntu firewall for Tautulli Server:
```
sudo ufw allow 8181
```
* [Install Nano and update packages](/install_nano/readme.md).
* [Install Docker](/install_docker/readme.md).
* Create directories for Tautulli Server:
```
sudo mkdir -p /opt/tautulliserver/{config,data}
```
-----
# Install Tautulli Server
* Enter Tautulli Server directory:
```
cd /opt/tautulliserver
```
* Download `docker-compose.yml` file from Github to set up the Tautulli Server Docker container:
```
sudo wget https://raw.githubusercontent.com/linw0724-linnet/ubuntu-server-setup/published/dckr_tautulli/docker-compose.yml
```
* Edit `docker-compose.yml` file:
```
sudo nano /opt/tautulliserver/docker-compose.yml
```
* Replace `<uid>` and `<gid>` with the proper user PUID and PGID that you want to use to run the server.
* Replace `<time-zone>` with the proper time zone name for your host machine.
* Save file and exit text editor.
* Test Tautulli Docker container:
```
sudo docker-compose -f /opt/tautulliserver/docker-compose.yml config
```
* Return to root:
```
cd
```
* Start Tautulli Docker container:
```
cd /opt/tautulliserver
sudo docker-compose up -d
```
* Return to root:
```
cd
```
-----
# Installation Status Check
* Check that TrueCommand Docker container is running:
```
sudo docker ps -a
```
-----
# Optional Scripting
* Set startup scripts:
```
crontab -e
```
* Add the following entries to the `crontab -e` file:
```
# Set Tautulli Docker container to auto update and restart on the first day of every month at 0500
0 5 1 * * docker restart tautulliserver
```
* Save file and exit text editor.
-----
# Using Tautulli Server
Tautulli Server is now set up in a Docker container on your host machine.

Go to the web UI for Deluge via a web browser under `<host-machine-IP-address>:8181` to finish setting up your Tautulli Server.

-----
# Update Tautulli Server
> [!NOTE]
> Since Tautulli is running in a Docker container, when Tautulli has a new update, you cannot update through the web user interface; you will have to pull a new docker container image to update the server.
* To update Tautulli Docker container:
```
cd /opt/tautulliserver
sudo docker-compose pull
sudo docker-compose up -d
```