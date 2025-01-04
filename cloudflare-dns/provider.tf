# Copyright 2025 Bitshift D.O.O
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.49.1"
    }
  }
}