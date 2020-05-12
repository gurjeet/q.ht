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
    ["A",    "*",    "46.166.184.99",              false],
    ["A",    "*",    "185.206.180.117",            false],
    ["A",    "q.ht", "46.166.184.99",              true ],
    ["A",    "q.ht", "185.206.180.117",            true ],
    ["A",    "www",  "46.166.184.99",              true ],
    ["A",    "www",  "185.206.180.117",            true ],
    ["AAAA", "*",    "2a00:1768:2001:63::46:99",   false],
    ["AAAA", "*",    "2a0b:1640:1:1:1:1:bb7:e646", false],
    ["AAAA", "q.ht", "2a00:1768:2001:63::46:99",   true ],
    ["AAAA", "q.ht", "2a0b:1640:1:1:1:1:bb7:e646", true ],
    ["AAAA", "www",  "2a00:1768:2001:63::46:99",   true ],
    ["AAAA", "www",  "2a0b:1640:1:1:1:1:bb7:e646", true ],
    # Record type, record name, IP Address/value, is-proxied?

    ["TXT", "_gitlab-pages-verification-code.q.ht", "gitlab-pages-verification-code=a0672e704d12da7b1ca76e71fed79f68", false],
    ["TXT", "_gitlab-pages-verification-code.www.q.ht", "gitlab-pages-verification-code=e0df8376078e36d180aa06e3de58d3b4", false],
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

