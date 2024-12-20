# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


locals {
  ssh_key_names = toset(flatten(concat([for srv in var.docean_server_list : srv.ssh_key_names if length(srv.ssh_key_names) > 0], var.docean_server_config.ssh_key_names)))
  vpc_names     = [for srv in var.docean_server_list : srv.vpc_name if srv.vpc_name != null]
  all_vpc_names = toset(var.docean_server_config.vpc_name != null ? concat(local.vpc_names, [var.docean_server_config.vpc_name]) : local.vpc_names)
}


data "digitalocean_vpc" "target_vpcs" {
  for_each = local.all_vpc_names
  name     = each.key
}

data "digitalocean_projects" "all_projects" {

}


data "digitalocean_ssh_keys" "required_ssh_keys" {
  filter {
    key    = "name"
    values = local.ssh_key_names
  }
}