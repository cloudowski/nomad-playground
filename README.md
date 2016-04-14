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

