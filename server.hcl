# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/tmp/server1"
bind_addr = "0.0.0.0"
#bind_addr = "10.14.14.11"
#
advertise {
  rpc = "10.14.14.11:4647"
}

# Enable the server
server {
    enabled = true
    # Self-elect, should be 3 or 5 for production
    bootstrap_expect = 1
}
