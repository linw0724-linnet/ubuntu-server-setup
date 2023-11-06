#!/bin/bash
# Checks if Torrent CIFS share is mounted to local Deluge downloads directory
if mountpoint -q /nas/delugeserverdownloads
  # If Torrent CIFS share is mounted to local Deluge downloads directory, do nothing
  then
    :
  # If Torrent CIFS share are not mounted, remount shares and restart Deluge container
  else
    sudo mount -a; sudo docker restart delugeserver
fi