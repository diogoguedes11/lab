#!/bin/bash

# Create the isolation with unshare
unshare --fork --cgroup --net --mount-proc --uts --pid

# Testing 
unshare /bin/bash
ps -A