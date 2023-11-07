#!/bin/bash
# Checks if Plex CIFS shares are mounted to local corresponding Plex Server directories
if [[ mountpoint -q /nas/plexserverdatabase || mountpoint -q /nas/plexserverphysicalmedia || mountpoint -q /nas/plexservertempmedia ]]
  # If Plex CIFS shares are mounted to local corresponding Plex Server directories, do nothing
  then
    :
  # If Plex Database CIFS share are not mounted to local corresponding Plex Server directories, remount shares and restart Plex container
  else
    sudo mount -a; sudo docker restart plexserver
fi