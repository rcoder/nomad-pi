datacenter = "homelab"
data_dir = "/opt/consul"

server = true
boostrap_expect = 3

advertise_addr = "{{ GetAllInterfaces | include \"flags\" \"forwardable|up\" | attr \"address\" }}"

ui = true

ports {
  grpc = 8502
}

connect {
  enabled = true
}
