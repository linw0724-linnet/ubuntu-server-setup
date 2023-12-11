#!/bin/bash
if [ mountpoint -q /nas/plexserverdatabase ] || [ mountpoint -q /nas/plexserverdatabasebackup ] || [ mountpoint -q /nas/plexserverphysicalmedia ] || [ mountpoint -q /nas/plexservertempmedia ] || [ mountpoint -q /nas/plexservertranscode ] || [ mountpoint -q /nas/plexserveroptimizedmedia ]
  then
    :
  else
    sudo mount -a; sudo docker restart plexserver
fi
