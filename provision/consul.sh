#!/bin/bash

export LC_ALL=C

. /vagrant/provision/options.sh


puppet module install KyleAnderson-consul

if [ $run_nomad_server = "y" ];then
	bootstrap="'bootstrap_expect' => 1,"
fi


cat << EOF > /tmp/consul.pp
\$servers = { 
	'nomad1' => { 'ip' => '10.14.14.11' },
	'nomad2' => { 'ip' => '10.14.14.12' },
	'nomad3' => { 'ip' => '10.14.14.13' },
	'nomad4' => { 'ip' => '10.14.14.14' },
	'nomad5' => { 'ip' => '10.14.14.15' },
	'nomad6' => { 'ip' => '10.24.14.16' },
	'nomad7' => { 'ip' => '10.24.14.17' },
}
create_resources(host, \$servers)
class { '::consul':
  version     => '0.6.4',
  config_hash => {
    $bootstrap
    'client_addr'      => '0.0.0.0',
    'data_dir'         => '/opt/consul',
    'datacenter'       => '$dc',
    'log_level'        => 'debug',
    'node_name'        => \$::hostname,
    'server'           => true,
    'ui_dir'           => '/opt/consul/ui',
    'advertise_addr'   => \$::ipaddress_eth1,
    'enable_syslog'   => true,
EOF

case $dc in
  dc1)
cat << EOF >> /tmp/consul.pp
    'start_join'   => ['10.14.14.11', '10.14.14.12', '10.14.14.13'],
    'retry_join'   => ['10.14.14.11', '10.14.14.12', '10.14.14.13'],
  }
}
EOF
  ;;
  dc2)
cat << EOF >> /tmp/consul.pp
    'start_join'   => ['10.14.14.14', '10.14.14.15', '10.14.14.16'],
    'retry_join'   => ['10.14.14.14', '10.14.14.15', '10.14.14.16'],
  }
}
EOF
;;
  dc3)
cat << EOF >> /tmp/consul.pp
    'start_join'   => ['10.24.14.16', '10.24.14.17'],
    'retry_join'   => ['10.24.14.16', '10.24.14.17'],
  }
}
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
