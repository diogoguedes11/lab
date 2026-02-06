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
# Run a process in the cgroup
echo $$ > cgroup.procs
# Check the memory limit
cat memory.max
# Run a process that exceeds the memory limit
stress --vm 1 --vm-bytes 50M --timeout 10s
# Check the memory usage
cat memory.current


