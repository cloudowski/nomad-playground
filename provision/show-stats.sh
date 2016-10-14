#!/bin/bash
echo "Region: PL"
echo "* nodes"
nomad node-status -region=pl -verbose -stats
echo "* jobs"
nomad status -region=pl
echo
echo "Region: US"
echo "* nodes"
nomad node-status -region=us -verbose -stats
echo "* jobs"
nomad status -region=us
echo "Region: US"
echo
echo "Servers"
nomad server-members
