#!/bin/bash

export LC_ALL=C

apt-get install -y haproxy
service haproxy stop

echo "Downloading consul-template"
cd /tmp
wget -Oconsul_template.zip https://releases.hashicorp.com/consul-template/0.14.0/consul-template_0.14.0_linux_amd64.zip
unzip -f consul_template.zip -d /usr/local/bin
