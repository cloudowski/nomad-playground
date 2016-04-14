#!/bin/bash

puppet module install KyleAnderson-consul

puppet apply /vagrant/provision/consul.pp
