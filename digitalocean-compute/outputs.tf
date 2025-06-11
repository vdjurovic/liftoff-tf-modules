# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


locals {
  server_name_vpc_name_map = { for key, srv in local.server_map : key => srv.vpc_name }
  srv_dns_map              = { for key, srv in local.server_map : key => srv.dns_zone }
}

output "server_info" {
  description = "Basic information about created servers"
  value = merge({ for srv in digitalocean_droplet.named_server : srv.name => {
    public_ip_v4 = srv.ipv4_address
    dns_zone     = local.srv_dns_map[srv.name]
    provider     = "digitalocean"
    private_net_info = [{
      net_id     = data.digitalocean_vpc.target_vpcs[local.server_name_vpc_name_map[srv.name]].id
      ip_address = srv.ipv4_address_private
      ip_range   = data.digitalocean_vpc.target_vpcs[local.server_name_vpc_name_map[srv.name]].ip_range
    }]
  } })
}