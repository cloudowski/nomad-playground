This configuration is for testing nomad configuration.
Currently it:
- launches 3 vm and install nomad and consul
- by using /vagrant/run.sh it launches 1 server on first node and 2 agents per each server
- agents register themselves in server
- there is a job called **x** defined in /vagrant/x.nomad which you can launch for testing - it uses docker to create 2 containers (redis+nginx). You can launch it from first node:

```nomad run /vagrant/x.nomad```
