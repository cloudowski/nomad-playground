#!/bin/bash

. /vagrant/provision/options.sh

opts="-region=$region"

[ "$dc" = "dc1" ] && bootstrap_opt="bootstrap_expect = 1"
[ "$region" = "us" ] && bootstrap_opt="bootstrap_expect = 1"
retry_join='"10.14.14.11", "10.14.14.14"'
[ "$region" = 'us' ] && retry_join='"10.24.14.16"'


cat << EOF > /tmp/server.hcl
log_level = "DEBUG"

data_dir = "/tmp/server"
bind_addr = "0.0.0.0"
advertise {
  rpc = "$myip:4647"
  serf = "$myip:4648"
}

# Enable the server
server {
    enabled = true
    $bootstrap_opt
    retry_join = [ $retry_join ]
}
EOF
#rm -fr /tmp/server

tmux kill-session -t server
pkill nomad
sleep 3

if [ $run_nomad_server = "y" ];then
	rm -fr /tmp/server
	echo "Running Nomad server in tmux session 'server'"
	tmux new -s server -d "nomad agent -config /tmp/server.hcl \"$opts\" -dc=$dc" 

	echo "Running consul-template with haproxy in tmux session 'haproxy'"
	tmux new -s haproxy -d "consul-template -config /vagrant/files/haproxy.json -consul localhost:8500"

fi

echo "Running Nomad client in tmux session 'client'"
cat << EOF > /tmp/client.hcl
log_level = "DEBUG"
data_dir = "/tmp/client"
enable_debug = true
name    = "${HOSTNAME}"
client {
    enabled = true
    servers = ["$srvip:4647"]
    network_interface = "eth1"
}
consul {
    address = "$myip:8500"
}
ports {
    http = 5656
}
EOF
#rm -fr /tmp/client${i}
tmux kill-session -t client${i}
tmux new -s client$i -d "nomad agent -config /tmp/client.hcl \"$opts\" -dc=$dc"
