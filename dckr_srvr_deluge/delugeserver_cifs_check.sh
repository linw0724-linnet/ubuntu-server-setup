#!/bin/bash
if mountpoint -q /nas/delugeserverdownloads
  then
    :
  else
    sudo mount -a; sudo docker restart delugeserver
fi
