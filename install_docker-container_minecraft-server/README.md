# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine

> [!NOTE]
> Skip any steps that have already been completed

This instruction set will set up a Minecraft Server inside a Docker container

-----
# Instructions
* [Fix 'A start job is running, wait for network to be configured' on bootup](/fix_network-bootup/README.md)

* [Enable Ubuntu firewall](/enable_firewall/README.md)

* [Install SSH Server](/install_ssh-server/README.md)

* Connect via PuTTY

* Set up Ubuntu firewall for Minecraft Server
```
sudo ufw allow <port>
```
* [Install Nano and update packages](/install_nano/README.md)

* [Install Docker](/install_docker/README.md)


-----
# Conclusion
Minecraft Server is now set up in a Docker container on your host machine