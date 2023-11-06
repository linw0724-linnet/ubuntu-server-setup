> [!NOTE]
> This instruction set assumes that you have already successfully completed a clean install of Ubuntu Server
-----
* Fix 'A start job is running, wait for network to be configured' on bootup
```
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl mask systemd-networkd-wait-online.service
```
