work segment#!/bin/bash

# READ ALL THE NOTES BELOW:

# This script installs K3s on a Raspberry Pi cluster. More specifically, it selects running Raspberry Pi machines in a
# subnetwork with a given CIDR range and creates their ssh # config names based on the <prefix>-<id> pattern and
# configures ssh credentials for accessing them remotely using Ansible. Then, it runs ansible playbook to install K3s
# on those machines and finally downloads Kubernetes config file from the control node of the cluster.
# A predefined host with the name given by variable MASTER_NODE is assigned the role of the K3s control (master) node.

# WARNING !!!!: do not enable WiFi on your Pi-s before running this script. Otherwise nmap below will add
#   your Pis' WiFi port addresses to file HOST_FILE which will offend the script. 

# NOTE 1: make sure that you have done this: sudo usermod -aG sudo [name-of-your-local-user]
# NOTE 2: remember to set cluster CIDR/mask (e.g., 192.168.2.0/24) as script parameter NETWORK; 
#   thus, a complete script invocation should take the form as: $ source ./install.sh 192.168.2.0/24
# NOTE 3: in the parameter list below, verify/adjust user/password for your cluster nodes
# MOTE 4: remember that file inventory/group_vars/all.yaml is also needed by Ansible playbook and if not present in 
#   right configuration then you have to prepare it manually.

NETWORK="$1"                          # cluster CIDR/mask, script parameter; remember to set it in the command line
USER_NAME="ubuntu"                    # adjust to your settings, user login for your cluster hosts
PASSWORD="raspberrypi"                # adjust to your settings, user password for your cluster RbPi-s
HOST_FILE="./cluster"                 # auxiliary file for storing IPs addresses of your hosts (needed by the script)
INVENTORY_FILE="inventory/hosts.ini"  # Ansible inventory file (created by the script from scratch)
CONFIG_FILE="$HOME/.ssh/config"       # ssh config file to store [hostname IP] pairs for RbPi hosts (to ssh to the RbPi-s)
ERROR_FILE="/tmp/ssh-copy_error.txt"  # error log file
SSH_KEY_FILE="$HOME/.ssh/id_rsa"      # your ssh key on the management host, if it does not exist it will be generated by the script
MASTER_GROUP="master"                 # Ansible group of hosts serving as master (one host in our case) - check Ansible files to understand the structure
MASTER_NODE="k3s01"                   # adjust the name prefix to your settings, apply this format: <cluster_node_prefix><1> (here cluster_node_prefix=kpi09)
WORKER_GROUP="node"                   # Ansible group of nodes serving as worker - check Ansible files to understand the structure
WORKER_NODE_PREF="k3s0"               # adjust the name prefix to your settings; for worker nodes apply this format:
                                      #   <cluster_node_prefix><consecutive_integer> (consecutive_integer=2,3,4)
CLUSTER_GROUP="cluster"               # Ansible group of all hosts in the cluster - check Ansible files to understand the structure
CURRENT_DATE=$(date +%m-%dT%T)        # date-time suffix to generate a unique name of Kubernetes "kubeconfig" file - to prevent accidental overwriting

# check the presence of NETWORK parameter
if [ $# -ne 1 ]; then
    echo "Network CIDR/mask missing, provide one and run again. Exiting."
    return 3
fi

# cleaning - delete the files (they are filled in each time from scratch)

if [ -e $CONFIG_FILE ]
then
    echo "removing $CONFIG_FILE"
    rm $CONFIG_FILE
else
    echo "$CONFIG_FILE not found, skipping"
fi

if [ -e $INVENTORY_FILE ]
then
    echo "removing $INVENTORY_FILE"
    rm $INVENTORY_FILE
else
    echo "$INVENTORY_FILE not found, skipping"
fi

if [ -e $HOST_FILE ]
then
    echo "removing $HOST_FILE"
    rm $HOST_FILE
else
    echo "$HOST_FILE not found, skipping"
fi

# discover active Raspberry Pis in your network segment and store their IP addresses in file HOST_FILE
  # Below, the nmap utility discovers Raspberry Pis by their MAC prefix according to prefix allocation for the
  #   Raspberry Pi Foundation (https://udger.com/resources/mac-address-vendor-detail?name=raspberry_pi_foundation).
  # Tip: awk will keep the value of a given variable (ipaddress in our case) unchanged until matching a pattern
  #   able to set a new value for this variable. Such a match can be found after reading several lines by awk
  #   (in our case, this happens on encountering a line with RbPi prefix - to check it, run $ sudo nmap -sn $NETWORK).
  # Note: if your management host is a VM then its network interface MUST be bridged not NAT. This is
  #   required so that nmap utility has proper visibility of the network.
echo "discovering the hosts in the given subnet"
sudo nmap -sn $NETWORK | awk '/^Nmap scan report for/{ipaddress=$NF}/28:CD:C1|B8:27:EB|D8:3A:DD|DC:A6:32|E4:5F:01|2C:CF:67/{print ipaddress}' | tr -d "()" > $HOST_FILE 
HOSTS_NUMBER="$(wc -l $HOST_FILE | awk '{print $1}')"

# check the number of hosts discovered
if [ "$HOSTS_NUMBER" -lt "1" ]; then
    echo "No active hosts discovered in network $NETWORK. Exiting."
    return 3
fi

echo "$HOSTS_NUMBER active hosts discovered"

# if ssh is missing, create
echo "creating .ssh if not present"
if [ ! -f $CONFIG_FILE ]; then
    mkdir -p ~/.ssh && chmod 700 ~/.ssh
    touch $CONFIG_FILE
    chmod 600 $CONFIG_FILE
fi

# check for the presence of your public key; if you do not have one a new key will be created
echo "handling public keys"
if [ ! -f $SSH_KEY_FILE ]; then
    ssh-keygen -q -t rsa -b 4096 -N "" -f $SSH_KEY_FILE
fi

if [ ! -f  $SSH_KEY_FILE ]; then
    echo "File '$SSH_KEY_FILE' not found!"
    return 1
fi

if [ ! -f $HOST_FILE ]; then
    echo "File '$HOST_FILE' not found!"
    return 2
fi

# iterate over hosts to configure local ssh files and upload your public key to the cluster hosts
echo "uploading public key to cluster hosts"
i=1
grep -v '^ *#' < $HOST_FILE | while IFS= read -r IP
do
    # we know the first item corresponds to the master (control) node while the rest are worker nodes
    # (the script would have to be updated if more control nodes were allowed for)
    if [ $i -eq 1 ]; then
        echo "Host $MASTER_NODE"
        {
            echo -e "Host $MASTER_NODE"
            echo -e "\tHostname $IP" 
            echo -e "\tUser $USER_NAME"
        } >> $CONFIG_FILE
    else
        echo "Host $WORKER_NODE_PREF$(($i))"
        {
            echo -e "Host $WORKER_NODE_PREF$(($i))"
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
        return 3
    fi
    i=$((i+1))
done

# create/fill in (from scratch) a complete Ansible inventory file for the cluster
echo "creating Ansible inventory file; remember to check global_vars/all.yaml"
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
        echo -e "$WORKER_NODE_PREF$(($i))" >> $INVENTORY_FILE
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
echo "entering Ansible playbook"
ansible-playbook playbook_install_k3s.yaml -i $INVENTORY_FILE
echo "playbook finished"

# create .kube directory if not present
echo "creating $HOME/.kube directory and copying cluster kubeconfig file into it"
if ! [ -d "$HOME/.kube" ]; then
    mkdir "$HOME/.kube"
    echo "Created $HOME/.kube directory"
else
    echo "Directory $HOME/.kube already exists"
fi

# download the config file (needed by kubectl) form the master node of the cluster
# Note: if you are already using .kube/config file to access other clusters then update it 
#   manually with the content of the downloaded file config-cluster-$CURRENT_DATE. Remember
#   to set appropriate context with kubctl before accessing your k3s cluster. If your RbPi
#   cluster is the only one that you will control, you can preserve the default name of the
#   copied file (config), and no other manual updates will be needed. In the later case, 
#   uncomment the scp command right below and comment out the one currently being active.

# use if kubeconfig file is named config - uncomment these two lines and comment out the three following
#scp $USER_NAME@$MASTER_NODE:~/.kube/config $HOME/.kube/config
#echo "Created kubeconfig file $HOME/.kube/config"

# use if kubeconfig file is named config-cluster-$CURRENT_DATE - these three lines to be commented out when using "config" name as above
scp $USER_NAME@$MASTER_NODE:~/.kube/config $HOME/.kube/config-cluster-$CURRENT_DATE
echo "Created kubeconfig file $HOME/.kube/config-cluster-$CURRENT_DATE"
echo "  - remember to rename it to \"config\" or use KUBECONFIG env variable, or run kubectl --kubeconfig <config-file-name> ..."

# environment variable - only useful for current boot, can be left commented
#export KUBECONFIG=~/.kube/config-cluster-$CURRENT_DATE

echo "install finished"
