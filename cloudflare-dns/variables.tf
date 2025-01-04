# Copyright 2025 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


variable "cf_dns_records" {
  description = "DNS records to create. Assumes all DNS zones already exist."
  type = set(object({
    zone  = string
    type  = string
    name  = string
    value = string
    ttl   = optional(number)
  }))
  default = []
}

variable "cf_dns_zones" {
  description = "DNS zones to create."
  type = set(object({
    name       = string
    account_id = string
  }))
  default = []

}
