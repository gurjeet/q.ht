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

locals {
  cf_zone_id = "e0ad5a6e3cae50b634d8233823f48d7c"
  gitlab_pages_ipv4_address = "35.185.44.232"
  all_records = [
    # Record type, record name, IP Address/value, is-proxied?
    ["A",   "@",    local.gitlab_pages_ipv4_address,        true  ],
    ["A",   "www",  local.gitlab_pages_ipv4_address,        true  ],
    ["TXT", "@",    "forward-email=g:gurjeet@singh.im",     false ],
    ["TXT", "@",    "forward-email=admin:gurjeet@singh.im", false ],
    ["TXT", "@",    "forward-email=info:gurjeet@singh.im",  false ],
    ["MX",  "q.ht", "mx1.forwardemail.net",                 false ],
    ["MX",  "q.ht", "mx2.forwardemail.net",                 false ],
  ]
}

resource "cloudflare_record" "root-level" {
  count   = length(local.all_records)
  zone_id = local.cf_zone_id
  type    = local.all_records[count.index][0]
  name    = local.all_records[count.index][1]
  value   = local.all_records[count.index][2]
  proxied = local.all_records[count.index][3]
}

