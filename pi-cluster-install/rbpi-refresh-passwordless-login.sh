#!/bin/bash
# Generating and copying new keys. Maybe can be useful some day ...
# NOTICE: remember to:
# 1. set host names for your cluster logging individually to each node:
#    $ ssh <user-name>@<ip-address>
#    $ hostnamectl set-hostname <hostname>
# 2. if needed, adjust key name in ansible inventory file inventory/hosts.ini \
#    in line with the ssh-copy-id part of this script

# first, remove existing keys for cluster nodes
ssh-keygen -R kpi091
ssh-keygen -R kpi092
ssh-keygen -R kpi093
ssh-keygen -R kpi094

# Set up Passwordless SSH Login on cluster nodes 
ssh-copy-id -i ~/.ssh/id_rsa ubuntu@192.168.2.91
ssh-copy-id -i ~/.ssh/id_rsa ubuntu@192.168.2.92
ssh-copy-id -i ~/.ssh/id_rsa ubuntu@192.168.2.93
ssh-copy-id -i ~/.ssh/id_rsa ubuntu@192.168.2.94

