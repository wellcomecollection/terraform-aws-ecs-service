RELEASE_TYPE: minor

Removes a data block referring to an IAM role in modules/secrets as this causes dependency issues in consumers.

Also renames the variable task_execution_role_name to role_name in modules/secrets to be clearer. Consumers will need to update their references accordingly.
