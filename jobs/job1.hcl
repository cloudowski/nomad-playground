job "job1" {
    datacenters = ["dc1", "dc2"]
    region = "pl"

    group "cache" {
        count = 12

        task "redis" {
            driver = "docker"
            config {
                image = "redis:2.8"
                port_map {
                  cache = 6379
                }
            }
            service {
                name = "${TASKGROUP}-redis"
                tags = ["global", "cache"]
                port = "cache"
                check {
                  type = "tcp"
                  interval = "10s"
                  timeout = "2s"
                }
            }
            resources {
              network {
                mbits = 10
                port "cache" {
                }
              }
            }
        }
      
        task "nginx" {
            driver = "docker"
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
              network {
                mbits = 10
                port "www" {
                }
              }
            }
        }
    }
}
