# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine.

If you see a task that says `A start job is running, wait for network to be configured` and the machine hangs on that task for a few minutes during bootup, this instruction set will disable that start job.

-----
# Disable Network Configuration Startup Job
* Fix `A start job is running, wait for network to be configured` on bootup:
```
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl mask systemd-networkd-wait-online.service
```