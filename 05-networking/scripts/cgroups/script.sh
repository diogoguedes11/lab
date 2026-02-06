#!/bin/bash

# Create the isolation with unshare
unshare --fork --cgroup --net --mount-proc --uts --pid

# Testing (networking if lo is down)
unshare ip link