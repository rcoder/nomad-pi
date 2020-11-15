datacenter = "homelab"
data_dir = "/opt/nomad"

client {
  enabled = true
}

server {
  enabled = true
  bootstrap_expect = 3
}
