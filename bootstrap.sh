#!/bin/bash
cd $(dirname $0)/playbooks
ansible-playbook -i inventory ./arch-user.yml
