RELEASE_TYPE: minor

Add optional `ephemeral_storage_size` variable to the task_definition module.

- The ephemeral storage block is now dynamic and can be excluded by setting `ephemeral_storage_size` to `null`
- Default value is `21` (the minimum allowed value)
- Updated README with module documentation
