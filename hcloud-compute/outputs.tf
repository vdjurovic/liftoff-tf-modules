# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


locals {
  network_ip_range_map = { for net in data.hcloud_network.networks : net.id => net.ip_range }
  srv_private_nets_map = { for srv in hcloud_server.named_server : srv.name => srv.network }
  srv_dns_map          = { for key, srv in local.server_map : key => srv.dns_zone }
}


output "server_info" {
  description = "Basic information about created servers"
  value = { for srv in hcloud_server.named_server : srv.name => {
    public_ip_v4 = srv.ipv4_address
    dns_zone     = local.srv_dns_map[srv.name]
    provider     = "hcloud"
    private_net_info = [
      for net in srv.network : {
        net_id     = net.network_id
        ip_address = net.ip
        ip_range   = local.network_ip_range_map[net.network_id]
      }
    ]
    }
  }

}
