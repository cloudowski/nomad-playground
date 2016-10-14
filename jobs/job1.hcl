job "job1" {
	datacenters = ["dc1", "dc2"]
	region = "pl"
	constraint {
		attribute = "${attr.kernel.name}"
		value = "linux"
	}
	update {
		# Stagger updates every 10 seconds
		stagger = "20s"
		# Update a single task at a time
		max_parallel = 1
	}

	group "cache" {
		count = 12

		restart {
			# The number of attempts to run the job within the specified interval.
			attempts = 10
			interval = "5m"
			# A delay between a task failing and a restart occurring.
			delay = "25s"
			mode = "delay"
		}
		task "redis" {
			driver = "docker"
			config {
				image = "redis:2.8"
				port_map {
					db = 6379
				}
			}

			service {
				name = "${TASKGROUP}-redis"
				tags = ["global", "cache"]
				port = "db"
				check {
					type = "tcp"
					interval = "10s"
					timeout = "2s"
				}
			}
			resources {
				cpu = 200 # 500 Mhz
				memory = 128 # 256MB
				network {
					mbits = 10
					port "db" {
					}
				}
			}

		}
		# Define a task to run
		task "nginx" {
			# Use Docker to run the task.
			driver = "docker"

			# Configure Docker driver with the image
			config {
				image = "gcr.io/google_containers/serve_hostname:1.1"
				port_map {
					www = 9376
				}
			}
			service {
				name = "${TASKGROUP}-www"
				tags = ["global", "www", "rest"]
				port = "www"
				check {
					type = "http"
					interval = "10s"
					path = "/"
					timeout = "2s"
				}
			}
			resources {
				cpu = 100 # 500 Mhz
				memory = 64 # 256MB
				network {
					mbits = 10
					port "www" {
					}
				}
			}
		}
	}
}
