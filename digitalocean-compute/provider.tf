# Copyright 2024 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = "~> 1.12.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.55.0"
    }
  }
}