#!/bin/bash
#read .env file in the same foldert as script
source .env

#check if docker volumes named "episode_inventory_better" and "episode_inventory_worse" exist
if [ ! "$(docker volume ls | grep -w episode_inventory_better)" ]; then
  #if not exists crete tehm based on nfs info provided in ENV variables
  docker volume create episode_inventory_better -d local -o type=nfs -o o=addr=$NFS_SERVER_BETTER,rw -o device=:$NFS_PATH_BETTER

fi
if [ ! "$(docker volume ls | grep -w episode_inventory_worse)" ]; then
  docker volume create episode_inventory_worse -d local -o type=nfs -o o=addr=$NFS_SERVER_WORSE,rw -o device=:$NFS_PATH_WORSE
fi

