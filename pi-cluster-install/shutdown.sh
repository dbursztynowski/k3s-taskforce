#!/bin/bash
# check the following links for the ansible command options used:
# https://www.jeffgeerling.com/blog/2018/reboot-and-wait-reboot-complete-ansible-playbook
# https://www.middlewareinventory.com/blog/ansible_wait_for_reboot_to_complete/
CLUSTER_FILE="shutdown-hosts.ini"
ansible all -i $CLUSTER_FILE -b -B 1 -P 0 -m shell -a "sleep 5 && shutdown now" -b
