RELEASE_TYPE: minor

    Provide `shared_secrets_logging` from modules/firelens as we have it here, so consumer does not need to look it up with remote data source (and provide single source of truth)
    Default `launch_types` to `["FARGATE"]` in modules/task_definition in order to simplify client config for the most common use case.
