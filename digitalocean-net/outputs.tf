# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0

output "created_vpcs" {
  value = digitalocean_vpc.vpc[*]
}
