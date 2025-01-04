# Copyright 2025 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


resource "cloudflare_record" "dns_record" {
  for_each = { for rec in var.cf_dns_records : "${rec.zone}:${rec.type}:${rec.name}" => rec }

  zone_id = local.dns_zone_id_map[each.value.zone]
  type    = each.value.type
  name    = each.value.name
  content = each.value.value
  ttl     = each.value.ttl
}

resource "cloudflare_zone" "dns_zone" {
  for_each   = { for zone in var.cf_dns_zones : zone.name => zone }
  account_id = each.value.account_id
  zone       = each.value.name

}
