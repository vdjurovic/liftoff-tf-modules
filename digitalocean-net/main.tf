

resource "digitalocean_vpc" "vpc" {
  for_each    = { for vpc in var.docean_vpcs : vpc.name => vpc }
  name        = each.value.name
  region      = each.value.region
  ip_range    = each.value.ip_range
  description = each.value.description != null ? each.value.description : ""
}

locals {
  # create map of projects for easier access
  projects_by_name_map = tomap({for proj in data.digitalocean_projects.all_projects.projects: proj.name => proj})
  # unique project names from vars
  project_names_set = toset([for vpc in var.docean_vpcs: vpc.project_name if vpc.project_name != null && vpc.project_name != "" && try(contains(keys(local.projects_by_name_map),vpc.project_name),false)])
  # map project names to VPC names
  project_name_to_vpc_name_map = {for name in local.project_names_set: name => [for vpc in var.docean_vpcs: vpc.name if vpc.project_name == name]}
}

resource "digitalocean_project_resources" "project_resources" {
  for_each = local.project_name_to_vpc_name_map
  project = local.projects_by_name_map[each.key].id
  resources = [for vpc_name in each.value: digitalocean_vpc.vpc[vpc_name].urn]
}