#!/bin/bash

export LC_ALL=C

apt-get install -y haproxy
service haproxy stop

echo "Downloading consul-template"
cd /tmp
curl -sSL https://releases.hashicorp.com/consul-template/0.14.0/consul-template_0.14.0_linux_amd64.zip -o consul_template.zip

unzip -u consul_template.zip -d /usr/local/bin
