# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  #config.vm.box = "puphpet/ubuntu1404-x64"
  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"

  config.vm.provision "docker" # Just install it

  # pl region hosts
  (1..5).each do |n|
    config.vm.define "nomad#{n}", autostart: true do |host|
        host.vm.network :private_network, :ip => "10.14.14.1#{n}"
        host.vm.hostname = "nomad#{n}"
    end
  end

  # us regin hosts
  (6..7).each do |n|
    config.vm.define "nomad#{n}", autostart: false do |host|
        host.vm.network :private_network, :ip => "10.24.14.1#{n}"
        host.vm.hostname = "nomad#{n}"
    end
  end

  config.vm.provision :shell, :path => "provision/consul.sh"
  config.vm.provision :shell, :path => "provision/nomad.sh"
  config.vm.provision :shell, :path => "provision/common.sh"
  config.vm.provision :shell, :path => "provision/haproxy.sh"


  # Increase memory for Virtualbox
  config.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
  end

end
