# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


locals {
  ssh_key_names = toset(flatten([for srv in var.docean_server_list : srv.ssh_key_names if length(srv.ssh_key_names) > 0]))
  vpc_names     = toset([for srv in var.docean_server_list : srv.vpc_name if srv.vpc_name != null])
}


data "digitalocean_vpc" "target_vpcs" {
  for_each = local.vpc_names
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