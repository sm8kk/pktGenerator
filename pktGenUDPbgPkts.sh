#!/bin/bash
# pktgen.conf -- Sample configuration for send on two devices on a UP system

#modprobe pktgen

if [[ `lsmod | grep pktgen` == "" ]]; then
   modprobe pktgen
fi

if [[ $1 == "" ]]; then
   pktNum=1000
else
   pktNum=$1
fi

if [[ $2 == "" ]]; then
   delta=16000
else
   delta=$2
fi

function pgset() {
    local result

    echo $1 > $PGDEV

    result=`cat $PGDEV | fgrep "Result: OK:"`
    if [ "$result" = "" ]; then
         cat $PGDEV | fgrep Result:
    fi
}

function pg() {
    echo inject > $PGDEV
    cat $PGDEV
}

# On UP systems only one thread exists -- so just add devices
# We use eth1, eth1

echo "Adding devices to run".

# Adding to kpktgend_$coreNum thread 
# kpktgend_0 for bg small TCP traffic
#PGDEV=/proc/net/pktgen/kpktgend_0
#pgset "rem_device_all"
#pgset "add_device eth2" #cannot add the same NIC in different threads
#pgset "max_before_softirq 1000"

# Configure the individual devices
#echo "Configuring devices for TCP bg (alias UDP pkts with src port 77 as pktGen does not have TCP support)"

#PGDEV=/proc/net/pktgen/eth1

#randomly choose between a packetsize between minPktSize and maxPktSize
#if this is enabled then no need to specify pkt_size
#minPktSz=400
#maxPktSz=1400

#pgset "clone_skb 0" #Number of identical copies of the same packet sent one after the other
#pgset "pkt_size $pktsize"
#pgset "min_pkt_size $minPktSz"
#pgset "max_pkt_size $maxPktSz"
#pgset "flag TXSIZE_RND"
#pgset "delay $delta"
#pgset "src_mac D8:9D:67:6F:E1:71"
#pgset "dst_mac  D8:9D:67:6E:FD:E9"

# Note
# By default pktgen uses the src IP address, we only change the
# udp src and dst ports to generate packets from different flows.
# When destination IP address was randomized a side effect was many unecessary
# ARP packets that interfere with our packet generation

#pgset "src_min 10.10.1.2"
#pgset "src_max 10.10.1.254"
#pgset "flag IPSRC_RND"
#pgset "dst 10.10.1.4"
#pgset "count 0" #pkt number to 0 for explicit stop of pktgen
#pgset "udp_src_min 77"
#pgset "udp_src_max 77"
#pgset "flag UDPSRC_RND"
#pgset "udp_dst_min 333"
#pgset "udp_dst_max 344"
#pgset "flag UDPDST_RND"
# Time to run

# Adding to kpktgend_$coreNum thread 
# kpktgend_1 for bg UDP traffic
PGDEV=/proc/net/pktgen/kpktgend_1
pgset "rem_device_all"
pgset "add_device eth1"
pgset "max_before_softirq 1000"

# Configure the individual devices
echo "Configuring devices for UDP bg"

PGDEV=/proc/net/pktgen/eth1

#randomly choose between a packetsize between minPktSize and maxPktSize
#if this is enabled then no need to specify pkt_size
minPktSz=400
maxPktSz=1400

pgset "clone_skb 0" #Number of identical copies of the same packet sent one after the other
#pgset "pkt_size $pktsize"
pgset "min_pkt_size $minPktSz"
pgset "max_pkt_size $maxPktSz"
pgset "flag TXSIZE_RND"
pgset "delay $delta"
pgset "src_mac d8:9d:67:6f:53:95"
pgset "dst_mac d8:9d:67:6f:42:b9"

# Note
# By default pktgen uses the src IP address, we only change the
# udp src and dst ports to generate packets from different flows.
# When destination IP address was randomized a side effect was many unecessary
# ARP packets that interfere with our packet generation

#pgset "src_min 10.10.1.2"
#pgset "src_max 10.10.1.254"
#pgset "flag IPSRC_RND"
pgset "dst 10.10.1.4"
pgset "count $pktNum" #pkt number to 0 for explicit stop of pktgen
pgset "udp_src_min 1000"
pgset "udp_src_max 10000"
pgset "flag UDPSRC_RND"
pgset "udp_dst_min 1000"
pgset "udp_dst_max 10000"
pgset "flag UDPDST_RND"
# Time to run

PGDEV=/proc/net/pktgen/pgctrl
pgset "start"
echo "Done"
