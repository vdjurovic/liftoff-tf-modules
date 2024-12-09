# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = "~> 1.10.1"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.49.1"
    }
  }
}
