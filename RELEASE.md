RELEASE_TYPE: minor

Remove deployment label from tags - this functionality does not work!

Consumers will need to upgrade their AWS provider (post 2.60.0), and use `ignore_tags`.

See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging
