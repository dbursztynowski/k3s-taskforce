#!/bin/bash

ansible-playbook get_temp.yaml -i pi-cluster-install/inventory/hosts.ini
# cat /sys/class/thermal/thermal_zone0/temp
