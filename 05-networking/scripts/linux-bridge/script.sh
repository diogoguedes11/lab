#!/bin/bash

# Ensure Root
if [ "$EUID" -ne 0 ]; then
    echo "You're not running as root user."
    exit 1
fi

echo "cleaning old namespaces..."
ip -all netns delete 2>/dev/null

create_bridge(){
  local nsname="$1"
  local ifname="$2"

  echo "creating bridge ${nsname}/${ifname}"
  ip netns add ${nsname}
  ip netns exec ${nsname} ip link set lo up
  ip netns exec ${nsname} ip link add ${ifname} type bridge
  ip netns exec ${nsname} ip link set ${ifname} up
}

create_end_host(){
    local host_nsname="$1"
    local host_ifname="$2"
    local bridge_nsname="$3"
    local bridge_ifname="$4"
    local bridge_peer_ifname="$5"
    local host_ip="$6"

    echo "--- Connecting ${host_nsname} to Bridge ${bridge_ifname} ---"
    
    #  Create Host Namespace
    ip netns add ${host_nsname}
    ip netns exec ${host_nsname} ip link set lo up

    #  Create Veth Pair 
    ip link add ${host_ifname} netns ${host_nsname} type veth peer name ${bridge_peer_ifname} netns ${bridge_nsname}

    #  Bridge 
    ip netns exec ${host_nsname} ip link set ${host_ifname} up
    ip netns exec ${bridge_nsname} ip link set ${bridge_peer_ifname} up

    #  Add IP to Host
    ip netns exec ${host_nsname} ip addr add ${host_ip} dev ${host_ifname}

    #  Attach bridge-side interface to the bridge
    ip netns exec ${bridge_nsname} ip link set ${bridge_peer_ifname} master ${bridge_ifname}
}


create_bridge bridge1 br1

create_end_host host1 eth0 bridge1 br1 v-h1 192.168.1.10/24
create_end_host host2 eth0 bridge1 br1 v-h2 192.168.1.11/24

echo "--- Testing Connectivity (Host1 -> Host2)..."
ip netns exec host1 ping -c 2 192.168.1.11