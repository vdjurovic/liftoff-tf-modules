# input variables

variable "global_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to be applied to all resources. Can be overriden on resource level"
}

variable "hcloud_server_list" {
  type = list(object({
    server_name              = optional(string, "server")
    os_image                 = optional(string, "ubuntu-24.04")
    instance_type            = optional(string, "cx22")
    location                 = optional(string)
    datacenter               = optional(string)
    user_data_file_path      = optional(string)
    ssh_key_names            = optional(list(string))
    enable_public_ipv4       = optional(bool, true)
    enable_public_ipv6       = optional(bool, false)
    labels                   = optional(map(string))
    keep_disk                = optional(bool, false)
    enable_backups           = optional(bool, false)
    enable_delete_protection = optional(bool, false)
    private_networks         = optional(list(string), [])
    num_servers              = optional(number, 1)
    enable_nat_gateway       = optional(bool, false)
  }))
  default = []
}

variable "hcloud_server_config" {
  type = object({
    server_name              = optional(string, "server")
    os_image                 = optional(string, "ubuntu-24.04")
    instance_type            = optional(string, "cx22")
    location                 = optional(string)
    datacenter               = optional(string)
    user_data_file_path      = optional(string)
    ssh_key_names            = optional(list(string))
    enable_public_ipv4       = optional(bool, true)
    enable_public_ipv6       = optional(bool, false)
    labels                   = optional(map(string))
    keep_disk                = optional(bool, false)
    enable_backups           = optional(bool, false)
    enable_delete_protection = optional(bool, false)
    private_networks         = optional(list(string), [])
    num_servers              = optional(number, 1)
    enable_nat_gateway       = optional(bool, false)
  })
  default = {
    num_servers = 0
  }
}
