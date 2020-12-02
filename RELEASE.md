RELEASE_TYPE: patch

Remove an IAM role that we're not using in the `service` module.
The role isn't used anywhere, and not published as a module output for callers to use.