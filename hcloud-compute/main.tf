
resource "hcloud_server" "server" {
  count       = var.hcloud_server_config.num_servers
  name        = var.hcloud_server_config.num_servers > 1 ? "${var.hcloud_server_config.server_name}-${count.index}" : var.hcloud_server_config.server_name
  image       = var.hcloud_server_config.os_image
  server_type = var.hcloud_server_config.instance_type
  location    = try(var.hcloud_server_config.location, null)
  datacenter  = try(var.hcloud_server_config.datacenter, null)
  user_data   = var.hcloud_server_config.user_data_file_path != null ? file(var.hcloud_server_config.user_data_file_path) : null
  ssh_keys    = var.hcloud_server_config.ssh_key_names
  # configure public IP addresses
  public_net {
    ipv4_enabled = var.hcloud_server_config.enable_public_ipv4
    ipv6_enabled = var.hcloud_server_config.enable_public_ipv6
  }
  keep_disk         = var.hcloud_server_config.keep_disk
  backups           = var.hcloud_server_config.enable_backups
  delete_protection = var.hcloud_server_config.enable_delete_protection
  dynamic "network" {
    for_each = var.hcloud_server_config.private_networks
    content {
      network_id = data.hcloud_network.networks[network.value].id
    }
  }
  labels = merge(var.global_labels, var.hcloud_server_config.labels)
}

resource "hcloud_server" "named_server" {
  for_each    = { for srv in var.hcloud_server_list : srv.server_name => srv }
  name        = each.value.server_name
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

