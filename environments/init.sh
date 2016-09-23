#!/bin/bash

if [[ ! -f /opt/puppetlabs/bin/puppet ]]; then
	apt -y update && apt -y upgrade
	apt install -qy git curl vim python bridge-utils

	curl -O http://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
	dpkg -i puppetlabs-release-pc1-xenial.deb
	apt update && apt install -qqy puppet-agent
fi

# if [[ ! -f /usr/bin/docker ]]; then
# 	curl -fsSL https://test.docker.com/ | sh
# 	usermod -aG docker ubuntu
# fi
