RELEASE_TYPE: minor

service:

*   Added variable `use_fargate_spot` to use Fargate Spot as the capacity provider for your tasks.
    This will switch *all* tasks in this service to use Fargate Spot -- it's an on-off switch, not a split of tasks between Spot/non-Spot instances.

    Only enable this flag for services with tasks that can be interrupted safely.

    See <https://aws.amazon.com/blogs/aws/aws-fargate-spot-now-generally-available/> for more details.

    It defaults to `false` to avoid breaking changes in existing services.
