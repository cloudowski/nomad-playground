#!/bin/bash

export LC_ALL=C

REGION=$1
DC=$2
[ "$REGION" ] || REGION="pl"
[ "$DC" ] || DC="dc1"

puppet module install KyleAnderson-consul

if [ $HOSTNAME = "nomad1" ];then
	bootstrap="'bootstrap_expect' => 1,"
fi


cat << EOF > /tmp/consul.pp
class { '::consul':
  version     => '0.6.4',
  config_hash => {
    $bootstrap
    'client_addr'      => '0.0.0.0',
    'data_dir'         => '/opt/consul',
    'datacenter'       => 'east-aws',
    'log_level'        => 'debug',
    'node_name'        => \$::hostname,
    'server'           => true,
    'ui_dir'           => '/opt/consul/ui',
    'advertise_addr'   => \$::ipaddress_eth1,
    'enable_syslog'   => true,
EOF

case $DC in
  dc1)
cat << EOF >> /tmp/consul.pp
    'start_join'   => ['10.14.14.11', '10.14.14.12', '10.14.14.13'],
    'retry_join'   => ['10.14.14.11', '10.14.14.12', '10.14.14.13'],
  }
}
\$servers = { 
	'nomad1' => { 'ip' => '10.14.14.11' },
	'nomad2' => { 'ip' => '10.14.14.12' },
	'nomad3' => { 'ip' => '10.14.14.13' },
}
create_resources(host, \$servers)
EOF
  ;;
  dc2)
cat << EOF >> /tmp/consul.pp
    'start_join'   => ['10.14.14.14', '10.14.14.15', '10.14.14.16'],
    'retry_join'   => ['10.14.14.14', '10.14.14.15', '10.14.14.16'],
  }
}
\$servers = { 
	'nomad4' => { 'ip' => '10.14.14.14' },
	'nomad5' => { 'ip' => '10.14.14.15' },
	'nomad6' => { 'ip' => '10.14.14.16' },
}
create_resources(host, \$servers)
EOF
;;
esac

puppet apply /tmp/consul.pp

echo "Enabling DNS forwarding"
apt-get install -y dnsmasq
cat << EOF > /etc/dnsmasq.d/consul
server=/consul/127.0.0.1#8600
EOF

echo "nameserver 127.0.0.1" > /etc/resolv.conf

service dnsmasq restart
