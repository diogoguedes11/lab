#!/bin/bash

unshare --fork --pid --mount-proc bash

mkdir /sys/fs/cgroup/cpu/cg1

echo $$ > /sys/fs/cgroup/cpu/cg1/cgroup.procs  # Automatically puts new processes in the cgroup (fork() will create a new process)

echo "+cpu +memory -io" > /sys/fs/cgroup/<parent>/cgroup.subtree_control

echo "50000 100000" > /sys/fs/cgroup/cg1/cpu.max

echo "100M" > /sys/fs/cgroup/cg1/memory.max