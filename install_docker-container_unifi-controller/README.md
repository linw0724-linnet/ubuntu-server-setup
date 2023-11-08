# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

> [!NOTE]
> Skip any steps that have already been completed

This instruction set will set up an Unifi Controller inside a Docker container on your host machine and allow for management of all your UniFi network devices

-----
# Instructions
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/README.md)

* [Enable Ubuntu firewall](/enable_firewall/README.md)

* [Install SSH Server](/install_ssh-server/README.md)

* Connect via PuTTY

* Set up Ubuntu firewall for Unifi Controller
```
sudo ufw allow <port>
```
* [Install Nano and update packages](/install_nano/README.md)

* [Install Docker](/install_docker/README.md)

* Create directories for Unifi Controller
```
sudo mkdir /opt/unificontroller
```

-----
# Conclusion
Unifi Controller is now set up in a Docker container on your host machine

Go to the web UI for your Unifi Controller via a web browser under `<host-machine-IP-address>:<port>` to manage your Unifi devices
