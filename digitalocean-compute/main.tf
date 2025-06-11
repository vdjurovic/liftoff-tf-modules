# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0



locals {
  # create map of projects for easier access
  projects_by_name_map = tomap({ for proj in data.digitalocean_projects.all_projects.projects : proj.name => proj })
  # unique project names from vars
  project_names_set = toset([for srv in var.docean_server_list : srv.project_name if srv.project_name != null && srv.project_name != "" && try(contains(keys(local.projects_by_name_map), srv.project_name), false)])
  # SSH key name to id map
  ssh_key_name_id_map = { for key in data.digitalocean_ssh_keys.required_ssh_keys.ssh_keys : key.name => key.id }
  # map servers to format 'name-number' when more than one server is created
  server_map = merge([
    for srv in var.docean_server_list : {
      for idx in range(srv.num_servers) :
      "${srv.num_servers == 1 ? srv.server_name : "${srv.server_name}-${idx + 1}"}" => srv
    }
  ]...)
  # map project names to server names
  project_name_to_server_name_map = { for name in local.project_names_set : name => [for key, srv in local.server_map : key if srv.project_name == name] }
}


resource "digitalocean_droplet" "named_server" {
  for_each    = local.server_map
  name        = each.key
  image       = each.value.os_image
  size        = each.value.instance_type
  region      = each.value.region
  user_data   = each.value.user_data_file_path != null ? file("${each.value.user_data_file_path}") : null
  ssh_keys    = toset([for kn in each.value.ssh_key_names : local.ssh_key_name_id_map[kn] if contains(keys(local.ssh_key_name_id_map), kn)])
  ipv6        = each.value.enable_public_ipv6
  tags        = length(each.value.tags) > 0 ? each.value.tags : var.global_tags
  resize_disk = each.value.resize_disk
  backups     = each.value.enable_backups
  vpc_uuid    = each.value.vpc_name != null ? data.digitalocean_vpc.target_vpcs[each.value.vpc_name].id : null
}

# assign named server to projects
resource "digitalocean_project_resources" "named_server_project_resources" {
  for_each  = local.project_name_to_server_name_map
  project   = local.projects_by_name_map[each.key].id
  resources = [for srv_name in each.value : digitalocean_droplet.named_server[srv_name].urn]
}


