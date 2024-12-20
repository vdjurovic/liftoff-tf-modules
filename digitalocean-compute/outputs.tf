# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


locals {
  server_name_vpc_name_map = { for srv in var.docean_server_list : srv.server_name => srv.vpc_name }
}

output "server_info" {
  description = "Basic information about created servers"
  value = merge({ for srv in digitalocean_droplet.droplet : srv.name => {
    public_ip_v4 = srv.ipv4_address
    private_net_info = {
      net_id     = data.digitalocean_vpc.target_vpcs[var.docean_server_config.vpc_name].id
      ip_address = srv.ipv4_address_private
      ip_range   = data.digitalocean_vpc.target_vpcs[var.docean_server_config.vpc_name].ip_range
    }
    } }, { for srv in digitalocean_droplet.named_server : srv.name => {
    public_ip_v4 = srv.ipv4_address
    private_net_info = {
      net_id     = data.digitalocean_vpc.target_vpcs[local.server_name_vpc_name_map[srv.name]].id
      ip_address = srv.ipv4_address_private
      ip_range   = data.digitalocean_vpc.target_vpcs[local.server_name_vpc_name_map[srv.name]].ip_range
    }
  } })
}