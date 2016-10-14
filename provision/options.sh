#!/bin/bash

# set variables for provisions scripts

N=${HOSTNAME##nomad}

# defaults
region=unknown
dc=dcX

# set region
case $N in
  1|2|3|4|5) region=pl;;
  6|7) region=us;;
esac

# set dc
case $N in
  1|2|3) dc=dc1;;
  4|5) dc=dc2;;
  6|7) dc=dc3;;
esac

# set server
case $N in
  1|2|3) srvip=10.14.14.11;;
  4|5) srvip=10.14.14.14;;
  6|7) srvip=10.14.14.16;;
esac

# am i a server?
run_nomad_server=n
case $N in
  1|4|6) run_nomad_server=y;;
esac

# set ip
myip="10.14.14.1$N"

