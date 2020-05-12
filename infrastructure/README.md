Infrastructure-as-Code
======================

We use Terraform for managing our infrastructure as code. Follow Cloudflare's
Terraform documentation to modify these files.

Refrain from storing anything sensitive in these files.

Some of our infrastructure is not yet manageable via code, e.g. the GitLab
configuration to serve our website cannot be tracked here, even though we point
our DNS records at GitLab's IP address.

Terraform
=========

We use Terraform for managing our infrastructure. To invoke the `terraform`
command, use the `-var` option to provide the parameters, as below.

    terraform plan -var "cloudflare_api_token=<token>"
    terraform apply -var "cloudflare_api_token=<token>"

