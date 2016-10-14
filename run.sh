#!/bin/bash

N=${HOSTNAME##nomad}

#dc="dc$N"
# default region
dc=dc1
[ $N -ge 4 ] && dc=dc2

case $N in
	1) region=pl;;
	2) region=us;;
esac

# use single region for now
region=pl
opts="-region=$region"
myip="10.14.14.1$N"
srvip="10.14.14.11"

[ "$dc" = "dc1" ] && bootstrap_opt="bootstrap_expect = 1"


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
    retry_join = ["10.14.14.11", "10.14.14.14"]
}
EOF
#rm -fr /tmp/server

tmux kill-session -t server
pkill nomad
sleep 3

if [ $N -eq 1 -o $N -eq 4 ];then
	echo "Running Nomad server in tmux session 'server'"
	tmux new -s server -d "nomad agent -config /tmp/server.hcl \"$opts\" -dc=$dc" 
#	exit 
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
