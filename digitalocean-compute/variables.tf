# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0


# global tags to be applied to all resource. Can be overriden on resource level
variable "global_tags" {
  type        = set(string)
  default     = []
  description = "Labels to be applied to all resources. Can be overriden on resource level"
}

variable "docean_server_config" {
  type = object({
    server_name         = optional(string, "server")
    os_image            = optional(string, "ubuntu-24-10-x64")
    instance_type       = optional(string, "s-1vcpu-1gb")
    region              = optional(string, "fra1")
    user_data_file_path = optional(string)
    ssh_key_names       = optional(list(string), [])
    enable_public_ipv6  = optional(bool, false)
    tags                = optional(set(string), [])
    resize_disk         = optional(bool, true)
    enable_backups      = optional(bool, false)
    vpc_name            = optional(string)
    num_servers         = optional(number, 1)
    project_name        = optional(string)
    dns_zone            = optional(string)
  })
  default = {
    num_servers = 0
  }
  description = "Droplet configuration"
}


variable "docean_server_list" {
  type = list(object({
    server_name         = string
    os_image            = optional(string, "ubuntu-24-10-x64")
    instance_type       = optional(string, "s-1vcpu-1gb")
    region              = optional(string, "fra1")
    user_data_file_path = optional(string)
    ssh_key_names       = optional(list(string), [])
    enable_public_ipv6  = optional(bool, false)
    tags                = optional(set(string), [])
    resize_disk         = optional(bool, true)
    enable_backups      = optional(bool, false)
    vpc_name            = optional(string)
    project_name        = optional(string)
    dns_zone            = optional(string)
  }))
  default     = []
  description = "List of different droplet configurations"
}
