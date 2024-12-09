# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0

output "created_networks" {
  value = hcloud_network.network[*]
}

output "created_subnets" {
  value = hcloud_network_subnet.subnet[*]
}

output "created_routes" {
  value = hcloud_network_route.route[*]
}