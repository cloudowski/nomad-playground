#!/bin/bash
[ $# -ne 1 ] && { echo "Usage: $0 N"; exit 2; }
nomad=nomad$1
vagrant up $nomad && vagrant ssh $nomad -c 'sudo /vagrant/run.sh'
