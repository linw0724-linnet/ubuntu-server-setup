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
sudo ufw allow 80
sudo ufw allow 443
```
* [Install Nano and update packages](/install_nano/README.md)

* [Install Docker](/install_docker/README.md)

* Create directory for TrueCommand
```
sudo mkdir -p /opt/truecommand/data
```
* Install TrueCommand Docker container
```
sudo docker run \--detach –name truecommand -v "/opt/truecommand/data:/data" -p port:80 -p ssl:443 --restart ixsystems/truecommand:latest
```
* Check that TrueCommand Docker container is running
```
sudo docker ps
```
* Go to on another machine and access `https://<IP_of_host_running_TrueCommand>:443` on a web browser to access TrueCommand

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
* Download latest TrueCommand Docker image
```
sudo docker image pull ixsystems/truecommand
```
* Start TrueCommand Docker with latest container image
```
sudo docker run --name truecommand -v "/opt/truecommand/data:/data" -p <host port>:80 sslport <host port>:443 --detach --restart ixsystems/truecommand:latest
```
* Check that TrueCommand Docker container is running
```
sudo docker ps
```
-----
# Conclusion
TrueCommand is now set up in a Docker container on your host machine

You can now configure your local TrueNAS machines with TrueCommand
