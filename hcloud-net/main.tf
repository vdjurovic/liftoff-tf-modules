
resource "hcloud_network" "network" {
  for_each = { for ntwrk in var.hcloud_networks : ntwrk.name => ntwrk }
  name     = each.value.name
  ip_range = each.value.ip_range
  labels =  merge(var.hcloud_global_labels, each.value.labels)
}

locals {
  subnets = flatten([
    for net_name, net in var.hcloud_networks : [
      for subnet_key, subnet in net.subnets != null ? net.subnets : [] : {
        net_id      = hcloud_network.network[net_name.name].id
        sbnet       = subnet
        sbnet_range = subnet.ip_range
      }
    ]
    ]
  )
}

resource "hcloud_network_subnet" "subnet" {
  for_each     = { for ns in local.subnets : ns.sbnet_range => ns }
  network_id   = each.value.net_id
  ip_range     = each.value.sbnet.ip_range
  type         = each.value.sbnet.type
  network_zone = each.value.sbnet.region
}

resource "hcloud_network_route" "route" {
  for_each = {for rt  in var.hcloud_net_routes: rt.network_id => rt }
  network_id = each.key
  destination = each.value.destination
  gateway = each.value.gateway
}