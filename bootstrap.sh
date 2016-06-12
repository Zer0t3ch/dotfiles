#!/bin/bash
cd $(dirname $0)/playbooks
os=$(uname -o 2> /dev/null)
id=${id:-$(id -u)}


# Check if ansible exists
ansible-playbook --help &> /dev/null
if [[ $? -eq 127 ]]; then
	echo "Ansible not detected on this system."
	exit 1
fi


# Check the OS (exit on non-GNU/Linux systems)
if [[ $os == "GNU/Linux" ]]; then
	dist_id=$(cat /etc/os-release | grep ID | cut -d= -f2-)
	[[ $id -eq 0 ]] && playbook_suffix="system" || playbook_suffix="user"
	playbook_file="${dist_id}-${playbook_suffix}.yml"
	if [[ -f $playbook_file ]]; then
		echo "===> Deploying with role: ${playbook_file}"
		ansible-playbook -i inventory "./${playbook_file}"
	else
		echo "No ${playbook_suffix} deployment configuration found for ${dist_id}"
		exit 1
	fi
else
	echo "Non-GNU/Linux systems not currently supported"
fi
