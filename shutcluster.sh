#!/bin/bash
#cd pi-cluster-install
#./pi-cluster-install/shutcluster.sh
CLUSTER_INV="./pi-cluster-install/inventory/hosts.ini"
ansible all -i $CLUSTER_INV -b -B 1 -P 0 -m shell -a "sleep 5 && shutdown now" -b

# temperature reading cmd
# vcgencmd measure_temp
# or
# cat /sys/class/thermal/thermal_zone0/temp
