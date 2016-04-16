# Overview
This configuration is for testing nomad configuration with example jobs

Currently it launches 3 VMs using vagrant and installs nomad with consul

# Let's play
 * Start virtual machines:

```
vagrant up
```

 * After vm starts you need to launch manually server and agent nodes. You can do it using the following command from each server (it will launch them in separate tmux sessions):

```
/vagrant/run.sh
```

 * There is a job called **x** defined in /vagrant/x.nomad which you can launch for testing - it uses docker to create 2 containers (redis+nginx). You can launch it from the first node (nomad1):


```
nomad run /vagrant/x.nomad
```

Now you can check job and node statuses (from nomad1 only):
```
nomad node-status
nomad status x
```

Please see official [getting started guide](https://www.nomadproject.io/intro/getting-started/install.html) for more details.

## HAProxy load-balancer

On server **nomad2** run.sh also launches consul-template which generates dynamically haproxy config and starts/reloads haproxy. So you can actually test it using url **[http://10.14.14.11/](http://10.14.14.11/)**. You can also see haproxy stats at **[http://10.14.14.11:1936/](http://10.14.14.11:1936/)**.


# TODO
 * Make some useful service instead of dummy redis and nginx
 * Divide VMs using region and name datacenters
 * Use single tmux session with windows
