# This is to provide first insight into what Ansible knows about the configuration of the environment
# where it runs and which it is expected to configure.

# Simple demo: checking inventory_hostname, ansible_hostname and IP addresses of local host

# What Ansible does by default at the very beginning of each play: gathers facts (detailed configuration information)
# about your hosts. In our example playbook hostnametest.yaml, we gather facts only about our local host. Similar information
# will be collected about remote target hosts which is shown in playbook test_hostvars_fields.yaml. One can also check facts
# using Ansible ad-hoc commands - this is also show in the examples below.

# Worth of noting is how detailed the gathered information is.
# - reading about gathering facts: 
#   https://www.middlewareinventory.com/blog/ansible-facts-list-how-to-use-ansible-facts/

# How to check facts
####################
# (all artifacts are in the folder, you only need to adjust the hostname to your environmant)

##### 1. using ansible ad-hoc command
# checking own (localhost) host
ansible localhost -m setup

# checking cluster hosts(s) using inventory file
ansible -i <inventory-file> <host-group-name> -m setup
# e.g. (your results will be stored in file gather.facts)
ansible -i ../inventory/hosts.ini master -m setup | tee gather.facts
ansible -i ../inventory/hosts.ini all -m setup | tee gather.facts

##### 2. or running a simple palybook
# (the results will be sent to standard output)

# this will be applied to your local machine (indicated in hostnametest.yaml)
ansible-playbook hostnametest.yaml

# this will be applied to hosts according to inventory
# all hosts
ansible-playbook -i ../inventory/hosts.ini test_hostvars_fields.yaml
# hosts belonging to group master
ansible-playbook -i ../inventory/hosts.ini master test_hostvars_fields.yaml 
