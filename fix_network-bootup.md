* Fix 'A start job is running, wait for network to be configured' on bootup
```
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl mask systemd-networkd-wait-online.service
```
