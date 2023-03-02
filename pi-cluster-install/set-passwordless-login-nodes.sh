#!/bin/bash
# NOTICE: remember to:
# 1. set host names for your cluster logging individually to each node:
#    $ ssh <user-name>@<ip-address>
#    $ hostnamectl set-hostname <hostname>
# 2. adjust ansible inventory file inventory/hosts.ini \
#    for the last part of this script

# remove existing keys for cluster nodes
ssh-keygen -R kpi091
ssh-keygen -R kpi092
ssh-keygen -R kpi093
ssh-keygen -R kpi094

# Set up Passwordless SSH Login on cluster nodes 
ssh-copy-id -i ~/.ssh/db_id_rsa.pub ubuntu@192.168.1.38
ssh-copy-id -i ~/.ssh/db_id_rsa.pub ubuntu@192.168.1.39
ssh-copy-id -i ~/.ssh/db_id_rsa.pub ubuntu@192.168.1.40
ssh-copy-id -i ~/.ssh/db_id_rsa.pub ubuntu@192.168.1.41

# upgrade hosts & set ufw to allow port 6443 (run script upgrade-host.sh on all hosts)
ansible all -i inventory/hosts.ini -m ansible.builtin.script -a "upgrade-host.sh" --become

