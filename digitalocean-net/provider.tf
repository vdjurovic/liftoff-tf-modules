terraform {
  required_version = "~> 1.10.1"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.45.0"
    }
  }
}
