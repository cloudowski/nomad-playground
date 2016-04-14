class { '::consul':
  version     => '0.6.4',
  config_hash => {
    'bootstrap_expect' => 1,
    'client_addr'      => '0.0.0.0',
    'data_dir'         => '/opt/consul',
    'datacenter'       => 'east-aws',
    'log_level'        => 'debug',
    'node_name'        => $::hostname,
    'server'           => true,
    'ui_dir'           => '/opt/consul/ui',
    'advertise_addr'   => $::ipaddress_eth1,
    'enable_syslog'   => true,
    'start_join'   => ['10.14.14.11', '10.14.14.12', '10.14.14.13'],
    'retry_join'   => ['10.14.14.11', '10.14.14.12', '10.14.14.13'],
  }
}

$servers = { 
	'nomad1' => { 'ip' => '10.14.14.11' },
	'nomad2' => { 'ip' => '10.14.14.12' },
	'nomad3' => { 'ip' => '10.14.14.13' },
}
create_resources(host, $servers)
