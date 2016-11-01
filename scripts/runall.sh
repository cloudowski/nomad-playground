#!/bin/bash


for i in nomad{1..7};do
  vagrant ssh $i -c 'sudo /vagrant/run.sh'
done

