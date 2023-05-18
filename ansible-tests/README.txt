
# Simple demo: checking inventory_hostname, ansible_hostname and IP addresses of local host

# What it does: gathers facts abot your local host
# - reading about gathering facts: 
#   https://www.middlewareinventory.com/blog/ansible-facts-list-how-to-use-ansible-facts/

# How to check facts
# (all artifacts are in the folder, you only need to adjust the hostname to your environmant)

# 1. using ansible ad-hoc command 
ansible <hostgroup> -m setup
# e.g. (your results will be stored in file gather.facts)
ansible -i test_hosts all -m setup | tee gather.facts

# 2. or running a simple palybook
# (your results will be sent to standard output)
ansible-playbook -i test_hosts hostnametest.yaml
