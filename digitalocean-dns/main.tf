# Copyright 2025 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


resource "digitalocean_record" "dns_record" {
  for_each = { for rec in var.do_dns_records : "${rec.zone}:${rec.type}:${rec.name}" => rec }

  domain = local.dns_zone_id_map[each.value.zone]
  type   = each.value.type
  name   = each.value.name
  # for CNAME records, ensure the value ends with a dot
  value = each.value.type == "CNAME" && !endswith(each.value.value, ".") ? "${each.value.value}." : each.value.value
  ttl   = each.value.ttl
}

resource "digitalocean_domain" "dns_zone" {
  for_each = { for zone in var.do_dns_domains : zone.name => zone }

  name       = each.value.name
  ip_address = each.value.ip_address

}
