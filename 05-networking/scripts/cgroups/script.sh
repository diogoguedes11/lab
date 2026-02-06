#!/bin/bash

# Create the isolation with unshare
sudo unshare --fork --pid --mount-proc --uts --net --ipc --user --map-root-user /bin/bash

# Testing 
unshare /bin/bash
ps -A
# create cgroups
mkdir /sys/fs/cgroup/container
cd /sys/fs/cgroup/container
echo "+memory" > cgroup.subtree_control
echo "30M" > memory.max
