RELEASE_TYPE: patch

task_definition/modules/env_vars:

*   A small change to the way the JSON string passed to ECS is constructed.
    In particular, environment variable definitions should now have a stable
    sort order, and not change order between plans.