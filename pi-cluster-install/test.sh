#!/bin/bash
#i=2
#WORKER_NODE="kpi09"
#MASTER_NODE="kpi091"
#USER_NAME="ubuntu"
#echo "Host $WORKER_NODE$(($i))"
#echo "scp $USER_NAME@$MASTER_NODE:~/.kube/config ~/.kube/config-cluster"
##export KUBECONFIG=~/.kube/config-cluster

# run this before running test.sh: sudo chmod +s  test.sh
NETWORK="$1"
sudo nmap -sP $NETWORK | awk '/^Nmap/{ipaddress=$NF}/28:CD:C1|B8:27:EB|DC:A6:32|E4:5F:01/{print ipaddress}' | tr -d '()'

#nmap --exclude $(hostname -I | awk '{print $1}') -A -T4 -n -p22 -Pn $NETWORK -oG - | awk '/Ubuntu/{print $2}'
