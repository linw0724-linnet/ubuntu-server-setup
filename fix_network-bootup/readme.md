# Introduction
> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server on your host machine.

If you see a task that says `A start job is running, wait for network to be configured` and the machine hangs on that task for a few minutes during bootup, this instruction set will disable that start job.

-----
# Instructions
* Fix `A start job is running, wait for network to be configured` on bootup:
```
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl mask systemd-networkd-wait-online.service
```
-----
# Conclusion
You should now no longer see `A start job is running, wait for network to be configured` during the bootup sequence on your host machine.
