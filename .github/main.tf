
module "hcloud_compute" {
  source = "../../tf-modules/hcloud-compute"
  hcloud_server_list = [
  { server_name        = "nat-gw-1"
    ssh_key_names      = ["hcloud_playground"]
    private_networks   = ["dev-net"]
    enable_nat_gateway = true
    labels = {
      "named" = "named-1"
    }
  }
]

global_labels = {
  "organozation" = "org"
  "project"      = "outer"
}
}

module "hcloud_net" {
  source = "../../tf-modules/hcloud-net"

hcloud_net_routes = flatten([for si in module.hcloud_compute.server_info: [
  for netinfo in si.private_net_info: {
    network_id = netinfo.net_id
    destination = "0.0.0.0/0"
    gateway = netinfo.ip_address
  }
]
])

}

output "compute_output" {
  value = module.hcloud_compute
}