RELEASE_TYPE: patch

The AWS provider has deprecated aws_region.name in favour of using aws_region.region

See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region#argument-reference

This change updates the module to use aws_region.region instead, silencing the deprecation warnings