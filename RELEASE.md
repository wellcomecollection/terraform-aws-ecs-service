RELEASE_TYPE: patch

Tweak the order of permissions in the execution role created by `task_definition/iam_role`.

This doesn't change the permissions we assign, but it does match the order in the final policy created in IAM – I'm hoping this reduces the diff churn on subsequent plan/apply cycles in Terraform.