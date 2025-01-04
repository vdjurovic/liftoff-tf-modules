# Copyright 2025 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0



locals {
  declared_dns_zone_names = toset([for record in var.do_dns_records : record.zone])
  dns_zone_id_map         = { for zone in local.declared_dns_zone_names : zone => data.digitalocean_domain.existing_domains[zone].id }
}

data "digitalocean_domain" "existing_domains" {
  for_each = local.declared_dns_zone_names
  name     = each.value
}
