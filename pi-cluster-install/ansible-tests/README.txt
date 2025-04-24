# This is to provide first insight into what Ansible knows about the configuration of the environment
# where it runs and which it is expected to configure.

# Simple demo: checking inventory_hostname, ansible_hostname and IP addresses of local host

# What Ansible does at the very beginning of its run: gathers facts (detailed configuration information)
# about your hosts. In our example, we gather facts only about our local host, but similar information
# will be collected about target hosts. Worth of noting is how detailed the gathered information is.
# - reading about gathering facts: 
#   https://www.middlewareinventory.com/blog/ansible-facts-list-how-to-use-ansible-facts/

# How to check facts
# (all artifacts are in the folder, you only need to adjust the hostname to your environmant)

# 1. using ansible ad-hoc command 
ansible <hostgroup> -m setup
# e.g. (your results will be stored in file gather.facts)
ansible -i ../inventory/hosts.ini all -m setup | tee gather.facts

# 2. or running a simple palybook
# (your results will be sent to standard output)
ansible-playbook hostnametest.yaml
ansible-playbook test_hostvars_fields.yaml -i ../inventory/hosts.ini
