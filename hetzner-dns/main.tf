# Copyright 2025 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


resource "hetznerdns_record" "dns_record" {
  for_each = { for rec in var.hcloud_dns_records : "${rec.zone}:${rec.type}:${rec.name}" => rec }

  zone_id = local.dns_zone_id_map[each.value.zone]
  type    = each.value.type
  name    = each.value.name
  value   = each.value.value
  ttl     = each.value.ttl
}

resource "hetznerdns_zone" "dns_zone" {
  for_each = { for zone in var.hcloud_dns_zones : zone.name => zone }

  name = each.value.name
  ttl  = each.value.ttl

}
