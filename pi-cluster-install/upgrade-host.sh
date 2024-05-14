#!/bin/bash

# Old script, was used to prepare target hosts before running install.ini and Ansible.
# Currently all this stuff has been moved to Ansible playbook.

# upgrade, install net tools
# $HOSTNAME - environment variable
MASTER_NODE="kpi091"

sudo apt-get update -y
echo "==========> '$HOSTNAME' update done"
sudo apt-get dist-upgrade -y
echo "==========> '$HOSTNAME' dist-upgrade1 done"
sudo apt-get install -y net-tools
echo "==========> '$HOSTNAME' net-tools done"
# nmap is not needed on hosts in our case
#sudo apt-get install -y nmap
#echo "==========> '$HOSTNAME' nmap done"
sudo apt-get dist-upgrade -y
echo "==========> '$HOSTNAME' dist-upgrade2 done"

# allow tcp/6443 on master node
if [ "$HOSTNAME" = "$MASTER_NODE" ]; then
   sudo ufw allow from any to any port 6443 proto tcp
   echo "==========> '$HOSTNAME' allow tcp/6443 done"
fi
echo "==========> '$HOSTNAME' pre-ansible finished"

