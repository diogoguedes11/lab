
if [ "$EUID" -ne 0 ]; then
    echo "You're not running as root user."
    exit
fi


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

        echo "---Connecting ${host_nsname} to Bridge ${bridge_ifname}"
        # Create end host namespace
        ip netns add ${host_nsname}
        ip netns exec ${host_nsname} ip link set lo up

        # Create a veth pair connecting end host and bridge namespace
        ip link add ${host_ifname} netns ${host_nsname} type veth pair name ${bridge_ifname} netns ${bridge_nsname}
        ip link exec ${host_nsname} ip link set ${host_ifname} up
        ip link exec ${bridge_nsname} ip link set ${bridge_peer_ifname} up

        # Add address space
        ip link exec ${host_nsname} exec ip adr add ${host_ip} dev ${host_ifname}

        # Attach  host interface to the bridge
        ip netns exec ${host_nsname} ip link set ${bridge_peer_ifname} master ${bridge_ifname}
}



create_bridge
create_end_host