> [!WARNING]
> The implementation of pulling files from Github has not yet been tested and needs verification
# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

> [!NOTE]
> Skip any steps that have already been completed

This instruction set will set up an Open Speed Test Server inside a Docker container on your host machine and allow for speed tests over your local network

-----
# Instructions
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/README.md)

* [Enable Ubuntu firewall](/enable_firewall/README.md)

* [Install SSH Server](/install_ssh-server/README.md)

* Connect via PuTTY

* Set up Ubuntu firewall for Deluge Server
```
sudo ufw allow 3000/tcp
sudo ufw allow 3001/udp
```
* [Install Nano and update packages](/install_nano/README.md)

* [Install Docker](/install_docker/README.md)

* Create directories for Open Speed Test Server
```
sudo mkdir /opt/openspeedtestserver
```
* Configure Open Speed Test Server Docker container
```
sudo nano /opt/openspeedtestserver/docker-compose.yml
```
* Enter configuration for Open Speed Test Server Docker container into compose file
```
version: "3.3"
services:
  speedtest:
    container_name: openspeedtestserver
    image: openspeedtest/latest
    restart: unless-stopped
    environment:
      - ENABLE_LETSENCRYPT=True
      - DOMAIN_NAME=speedtest.lin-net.net
      - USER_EMAIL=williaml@lin-net.net
      - VERIFY_OWNERSHIP="TXT-FILE-CONTENT"
    ports:
      - '3000:3000'
      - '3001:3001'
```
* Save file and exit text editor

* Test Open Speed Test Server Docker container
```
sudo docker-compose -f /opt/openspeedtestserver/docker-compose.yml config
```
* Start Open Speed Test Server Docker container
```
cd /opt/openspeedtestserver
sudo docker-compose up -d
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
# Set Open Speed Test Server Docker container to auto update and restart daily at 0500
0 5 * * * docker restart openspeedtestserver
```
* Save file and exit text editor
-----
# Conclusion
Open Speed Test Server is now set up in a Docker container on your host machine

Go to the web UI for Open Speed Test via a web browser under `<host-machine-IP-address>:3000` to conduct a speed test
