#!/bin/bash


create_bridge(){
  local nsname="bridge1"
  local ifname="br1"

  echo "creating bridge ${nsname}/${ifname}"
  ip netns add ${nsname}
  ip netns exec ${nsname} ip link set lo up
  ip netns exec ${nsname} ip link add ${ifname} type bridge
  ip netns exec ${nsname} ip link set ${ifname} up
}




create_end_host(){
        local host_nsname="host-ns"
        local bridge_nsname="bridge1"
        local bridge_ifname="br1"
        local peer1_ifname="eth-peer1"
        local peer2_ifname="eth-peer2"

        echo "creating end host ${host_nsname} connected to ${bridge_nsname}/${bridge_ifname}"
        # Create end host namespace
        ip netns add ${host_nsname}
        ip netns exec ${host_nsname} ip link set lo up


}



create_bridge
create_end_host