# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


locals {
  network_names = concat(var.hcloud_server_config.private_networks, flatten(var.hcloud_server_list[*].private_networks))
}

data "hcloud_network" "networks" {
  for_each = toset(local.network_names)
  name     = each.value
}