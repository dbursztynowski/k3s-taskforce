#!/bin/bash

# READ ALL THE NOTES BELOW:

# This script selects running Raspberry Pi machines in a subnetwork with a given CIDR range and creates their ssh 
# config names based on the <prefix>-<id> pattern and configures ssh credentials for accessing them remotely using ansible. 
# Finaly, it runs ansible playbook to install K3s cluster on those machines.
# A predefined host with the name given by variable MASTER_NODE is assigned the role of the k3s master in the cluster.

# NOTICE 0: (not important now) set from command line: "$ sudo chmod +s <this-script-name> " to let "sudo nmap ..." run
#   without asking for password.
# NOTICE 1: remember to set cluster CIDR/mask (e.g., 192.168.1.0/24) as script parameter NETWORK; 
#   thus, a complete script invocation should take the form as, e.g.: ./install.sh 192.168.1.0/24
# NOTICE 2: remember to set the date in the name of file config-cluster-<date> at the last but one line
#   and verify/align user/password for your cluster nodes

NETWORK="$1"                          # cluster CIDR/mask, script parameter; remember to set it in a script call
USER_NAME="ubuntu"                    # adjust to your settings, login user for your cluster hosts
PASSWORD="raspberry"                  # adjust to your settings, password for your cluster hosts
HOST_FILE="./cluster"                 # auxiliary file for IPs addresses of your hosts
INVENTORY_FILE="inventory/hosts.ini"  # Ansible inventory file
CONFIG_FILE="$HOME/.ssh/config"       # ssh config file to store [hostname IP] pairs for RbPi hosts (to ssh to the RbPi-s)
ERROR_FILE="/tmp/ssh-copy_error.txt"  # error log file
SSH_KEY_FILE="$HOME/.ssh/id_ed25519"  # your ssh key, if it does not exist it will be generated
MASTER_GROUP="master"                 # Ansible group of hosts serving as master (one host in our case) - check Ansible files to understand the structure
MASTER_NODE="kpi061"                  # adjust name prefix to your settings, apply the name format assumed: <your_cluster_prefix><1>
WORKER_GROUP="node"                   # Ansible group of nodes serving as worker - check Ansible files to understand the structure
WORKER_NODE="kpi06"                   # adjust name prefix to your settings, apply the name format assumed: <your_cluster_prefix><consecutive_integer>
CLUSTER_GROUP="cluster"               # Ansible group of all hosts in the cluster - check Ansible files to understand the structure
CURRENT_DATE=$(date +%m-%dT%T)        # date-time to generate a unique name of Kubernetes "config" file

# check the presence of NETWORK parameter
if [ $# -ne 1 ]; then
    echo "Network CIDR/mask missing, provide one and run again. Exiting."
    exit 3
fi

# delete the files
rm $HOST_FILE
rm $INVENTORY_FILE

# discover active Raspberry Pis in the network, store their IP addresses in HOST_FILE
  #old version: sudo nmap --exclude $(hostname -I | awk '{print $1}') -A -T4 -n -p22 -Pn $NETWORK -oG - | awk '/Ubuntu/{print $2}' > $HOST_FILE
  # better, more selective version - selecting by Raspberry Pi MAC prefixes (the former selects only by OS Ubuntu) \
  # instructive version: sudo nmap -sP 192.168.1.0/24 | awk '/^Nmap/{line=$0}/28:CD:C1|B8:27:EB|DC:A6:32|E4:5F:01/{print line}' | awk '{print $5, $6}' | tr -d '()'
sudo nmap -sP $NETWORK | awk '/^Nmap/{ipaddress=$NF}/28:CD:C1|B8:27:EB|DC:A6:32|E4:5F:01/{print ipaddress}' | tr -d "()" > $HOST_FILE
HOSTS_NUMBER="$(wc -l $HOST_FILE | awk '{print $1}')"
# check the number of hosts discovered
if [ "$HOSTS_NUMBER" -lt "1" ]; then
    echo "No active hosts discovered in network $NETWORK. Exiting."
    exit 3
fi

# if ssh empty, create
if [ ! -f $CONFIG_FILE ]; then
    mkdir -p ~/.ssh && chmod 700 ~/.ssh
    touch $CONFIG_FILE
    chmod 600 $CONFIG_FILE
fi

# check for the presence of your public key; if you do not have one a new key will be created
if [ ! -f $SSH_KEY_FILE ]; then
    ssh-keygen -q -t rsa -b 4096 -N "" -f $SSH_KEY_FILE
fi

if [ ! -f  $SSH_KEY_FILE ]; then
    echo "File '$SSH_KEY_FILE' not found!"
    exit 1
fi

if [ ! -f $HOST_FILE ]; then
    echo "File '$HOST_FILE' not found!"
    exit 2
fi

# iterate over hosts to configure local ssh files and upload your public key to the cluster hosts
i=1
grep -v '^ *#' < $HOST_FILE | while IFS= read -r IP
do
    if [ $i -eq 1 ]; then
        echo "Host $MASTER_NODE"
        {
            echo -e "Host $MASTER_NODE"
            echo -e "\tHostname $IP" 
            echo -e "\tUser $USER_NAME"
        } >> $CONFIG_FILE
    else
        echo "Host $WORKER_NODE$(($i))"
        {
            echo -e "Host $WORKER_NODE$(($i))"
            echo -e "\tHostname $IP"
            echo -e "\tUser $USER_NAME"
        } >> $CONFIG_FILE
    fi
    ssh-copy-id -p 22 -i $SSH_KEY_FILE $USER_NAME@$IP 2>$ERROR_FILE
    ERROR_CODE=$?
    if [ $ERROR_CODE -eq 0 ]; then
        echo "Public key successfully copied to $IP"
    else
        cat $ERROR_FILE
        echo 
        exit 3
    fi
    i=$((i+1))
done

# create/fill in (from scratch) Ansible inventory file for the cluster
for ((i=1; i<=HOSTS_NUMBER; i++))
do
    if [ $i -eq 1 ]; then
        echo -e "[$MASTER_GROUP]" > $INVENTORY_FILE
    {
        echo -e "$MASTER_NODE"
        echo ""
        echo -e "[$WORKER_GROUP]"
    } >> $INVENTORY_FILE
    else
        echo -e "$WORKER_NODE$(($i))" >> $INVENTORY_FILE
    fi
done

{
    echo ""
    echo -e "[$CLUSTER_GROUP:children]"
    echo -e "$MASTER_GROUP\n$WORKER_GROUP"
    echo ""
    echo -e "[$CLUSTER_GROUP:vars]"
    echo -e "ansible_user=$USER_NAME"
    echo -e "ansible_become_method=sudo"
    echo -e "ansible_become_pass=$PASSWORD"
    echo -e "ansible_ssh_private_key_file=$SSH_KEY_FILE"
    echo -e "cfg_static_network=true"
} >> $INVENTORY_FILE

# run ansible playbook installing k3s on cluster hosts
ansible-playbook playbook_install_k3s.yaml -i $INVENTORY_FILE

if [ ! -d "$HOME/.kube" ]; then
    mkdir "$HOME/.kube"
    echo "Created ~/.kube directory"
else
    echo "Directory ~/.kube already exists"
fi

# download the config file (for the use with kubectl) form the master node of the cluster 
scp $USER_NAME@$MASTER_NODE:~/.kube/config ~/.kube/config-cluster-$CURRENT_DATE

# environment variable - for current boot use only, can be left commented
#export KUBECONFIG=~/.kube/config-cluster-$CURRENT_DATE

