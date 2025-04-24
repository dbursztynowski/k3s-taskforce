#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Provide 2 - LAN interface name and ZT interface name."
    exit
fi

if [ $# -eq 1 ]
  then
    echo "Please provide one more argument. 1 - LAN interface, 2 - ZT interface"
    exit
fi

if [ $# -eq 2 ]
  then
## Run once commands - uncomment before the first execution of the
##   script and commnet again afterwards
#    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
#    echo "net.ipv4.conf.default.rp_filter=2" >> /etc/sysctl.conf
    sysctl -p

    iptables -t nat -A POSTROUTING -o $1 -j MASQUERADE
    iptables -A FORWARD -i $1 -o $2 -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -i $2 -o $1 -j ACCEPT
    echo "OK"
fi
