output "created_vpcs" {
  value = digitalocean_vpc.vpc[*]
}

output "project_names" {
  value = local.project_names_set
}