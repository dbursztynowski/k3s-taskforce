#!/bin/bash
# check the following links for the ansible command options used:
# https://www.jeffgeerling.com/blog/2018/reboot-and-wait-reboot-complete-ansible-playbook
# https://www.middlewareinventory.com/blog/ansible_wait_for_reboot_to_complete/
#CLUSTER_INV="shutdown-hosts.ini"
CLUSTER_INV="inventory/hosts.ini"
ansible all -i $CLUSTER_INV -b -B 1 -P 0 -m shell -a "sleep 5 && shutdown now" -b
