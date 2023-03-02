#!/bin/bash

# remove existing keys for cluster nodes
# ssh-keygen -R kpi0x1 && ssh-keygen -R kpi0x2 && ssh-keygen -R kpi0x3 && ssh-keygen -R kpi0x4
ssh-keygen -R kpi061
ssh-keygen -R kpi062
ssh-keygen -R kpi063
ssh-keygen -R kpi064

# Set up Passwordless SSH Login on cluster nodes
ssh-copy-id -i ~/.ssh/db_id_rsa.pub ubuntu@192.168.1.80
ssh-copy-id -i ~/.ssh/db_id_rsa.pub ubuntu@192.168.1.81
ssh-copy-id -i ~/.ssh/db_id_rsa.pub ubuntu@192.168.1.82
ssh-copy-id -i ~/.ssh/db_id_rsa.pub ubuntu@192.168.1.83

# upgrade hosts & set ufw on master node to allow port 6443 (run script upgrade-host.sh on all hosts)
ansible all -i inventory/hosts.ini -m ansible.builtin.script -a "upgrade-host.sh" --become

