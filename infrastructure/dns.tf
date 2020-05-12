terraform {
  required_version = "~> 0.12"
  required_providers {
    cloudflare = "~> 2.0"
  }
}

provider "cloudflare" {
  version = "~> 2.0"
  api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {
  # Terraform will prompt for the token.
  type = string
  description = "Provide the token that has at least {\"Permissions\": \"Zone.DNS\", \"Resources\": \"All zones\"}"
}

variable "cf_zone_id" {
    default = "e0ad5a6e3cae50b634d8233823f48d7c"
}

variable "all_records" {
  default = [
    # Record type, record name, IP Address/value, is-proxied?
    ["A",    "@",   "35.185.44.232", true],
    ["A",    "www", "35.185.44.232", true ],
    ["TXT", "@", "forward-email=g:gurjeet@singh.im",     false],
    ["TXT", "@", "forward-email=admin:gurjeet@singh.im", false],
    ["TXT", "@", "forward-email=info:gurjeet@singh.im",  false],
  ]
}

resource "cloudflare_record" "root-level" {
  count   = length(var.all_records)
  zone_id = var.cf_zone_id
  type    = var.all_records[count.index][0]
  name    = var.all_records[count.index][1]
  value   = var.all_records[count.index][2]
  proxied = var.all_records[count.index][3]
}

