#!/bin/bash

N=${HOSTNAME##nomad}

dc="dc$N"

case $N in
	1) region=europe;;
	2) region=asia;;
	3) region=australia;;
esac
region=poland

opts="-region=$region"
myip="10.14.14.1$N"
srvip="10.14.14.11"


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
    bootstrap_expect = 1
    start_join = ["10.14.14.11", "10.14.14.12", "10.14.14.13"]
}
EOF
rm -fr /tmp/server

tmux kill-session -t server
pkill nomad
sleep 3

if [ $N -eq 1 ];then
	echo "Running server"
	tmux new -s server -d "nomad agent -config /tmp/server.hcl \"$opts\""
#	exit 
fi

for i in {1..1};do
	echo "Running client $i"
cat << EOF > /tmp/client${i}.hcl
log_level = "DEBUG"
data_dir = "/tmp/client$i"
enable_debug = true
name    = "${HOSTNAME}_$i"
client {
    enabled = true
    servers = ["$srvip:4647"]
    network_interface = "eth1"
    options {
	    consul.address = "$myip:8500"
    }
}
ports {
    http = ${i}5656
}
EOF
	rm -fr /tmp/client${i}
	tmux kill-session -t client${i}
	#tmux new -s client$i -d "nomad agent -config /tmp/client${i}.hcl \"$opts\" -dc=dc$i"
	tmux new -s client$i -d "nomad agent -config /tmp/client${i}.hcl \"$opts\""
done
