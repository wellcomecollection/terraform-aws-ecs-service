RELEASE_TYPE: minor

Remove the `deployment_env` and `deployment_service` variables from the service module, which were used by weco-deploy.
We're no longer using weco-deploy (see [wellcomecollection/platform#5631](https://github.com/wellcomecollection/platform/issues/5631)), so we don't need these tags/variables.