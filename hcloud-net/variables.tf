# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


variable "hcloud_networks" {
  type = set(object({
    name                     = string
    ip_range                 = string
    delete_protection        = optional(bool)
    expose_routes_to_vswitch = optional(bool)
    labels                   = optional(map(string))
    subnets = optional(set(object({
      type       = string
      region     = string
      ip_range   = string
      vswitch_id = optional(string)
    })))
  }))
  default = []
}

variable "hcloud_net_routes" {
  type = set(object({
    network_id  = string
    destination = string
    gateway     = string
  }))
  default = []
}

variable "hcloud_global_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to be applied to all resources. Can be overriden on resource level"
}