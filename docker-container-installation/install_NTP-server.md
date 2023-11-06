> [!WARNING]
> This instruction set is still under development and untested, please make any contributions and edits to help finalize this instruction set

# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

> [!NOTE]
> Skip any steps that have already been completed

This instruction set will set up a NTP server inside a Docker container that can be used on your local network

-----
# Instructions

* [Fix 'A start job is running, wait for network to be configured' on bootup](fix_network-bootup.md)

* [Enable Ubuntu firewall](enable_firewall.md)

* [Install SSH Server](install_ssh-server.md)

* Connect via PuTTY

* Set up Ubuntu firewall for BIND9 DNS Server
```
sudo ufw allow 123
```
* [Install Nano and update packages](install_nano.md)

* [Install Docker](install_docker.md)

* Create directory for NTP Server
```
sudo mkdir -p /opt/ntpserver
```
* Configure NTP Server Docker container
```
sudo nano /opt/ntpserver/docker-compose.yml
```
* Enter configuration for NTP Server Docker container into compose file
```
version: '3.9'
services:
  ntp:
    container_name: ntpserver
    image: cturra/ntp:latest
    restart: always
    build: .
    environment:
      - NTP_SERVERS=pool.ntp.org
      - LOG_LEVEL=0
    ports:
      - '123:123/udp'
```
* Save file and exit text editor

* Test NTP Server Docker container
```
sudo docker-compose -f /opt/ntpserver/docker-compose.yml config
```
* Start BIND9 Docker container
```
cd /opt/ntpserver
sudo docker-compose up -d
```
* Return to root
```
cd
```
* Testing NTP server
```
apt install sntp
docker exec ntpserver chronyc tracking
docker exec ntpserver chronyc sources
docker exec ntpserver chronyc sourcestats
```
-----
# Conclusion
NTP Server is now set up in a Docker container on your host machine

You can now configure your local network clients to point to the host machine IP address for their NTP Server entry

You can also set the host machine IP address to be distributed as the NTP Server address via DHCP
