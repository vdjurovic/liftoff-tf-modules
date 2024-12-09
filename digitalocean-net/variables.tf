# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


variable "docean_vpcs" {
  type = set(object({
    name         = string
    region       = string
    ip_range     = string
    description  = optional(string)
    project_name = optional(string)
  }))
}