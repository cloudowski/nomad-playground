#!/bin/bash

# Update apt and get dependencies
sudo apt-get update
sudo apt-get install -y unzip curl wget vim tmux

# Download Nomad
echo Fetching Nomad...
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/0.4.1/nomad_0.4.1_linux_amd64.zip -o nomad.zip

echo Installing Nomad...
unzip -u nomad.zip
sudo chmod +x nomad
sudo mv nomad /usr/bin/nomad

sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d

