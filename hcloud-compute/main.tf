# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


locals {
  # map servers to format 'name-number' when more than one server is created
  server_map = merge([
    for srv in var.hcloud_server_list : {
      for idx in range(srv.num_servers) :
      "${srv.num_servers == 1 ? srv.server_name : "${srv.server_name}-${idx + 1}"}" => srv
    }
  ]...)
}

resource "hcloud_server" "named_server" {
  for_each    = local.server_map
  name        = each.key
  image       = each.value.os_image
  server_type = each.value.instance_type
  location    = try(each.value.location, null)
  datacenter  = try(each.value.datacenter, null)
  user_data   = each.value.user_data_file_path != null ? file(each.value.user_data_file_path) : null
  ssh_keys    = each.value.ssh_key_names
  # configure public IP addresses
  public_net {
    ipv4_enabled = each.value.enable_public_ipv4
    ipv6_enabled = each.value.enable_public_ipv6
  }
  keep_disk         = each.value.keep_disk
  backups           = each.value.enable_backups
  delete_protection = each.value.enable_delete_protection
  dynamic "network" {
    for_each = each.value.private_networks
    content {
      network_id = data.hcloud_network.networks[network.value].id
    }
  }
  labels = merge(var.global_labels, each.value.labels)
}

