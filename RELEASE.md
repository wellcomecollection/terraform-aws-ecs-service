RELEASE_TYPE: minor

This adds a variable `use_privatelink_endpoint` to the `firelens` module, which causes logs to be sent via the PrivateLink endpoint instead of over the public Internet/NAT Gateway.

This must be accompanied by an appropriate security group.
