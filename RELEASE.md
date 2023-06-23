RELEASE_TYPE: minor

This implements some basic economy measures in the `service` module: services can now be disabled outside UK office hours.

In particular, if you set `turn_off_outside_office_hours = true`, then:

-   Every weekday evening, the service will be scaled down to 0
-   Every weekday morning, the service will be scaled up to its desired task count

This is only meant for persistently-running services -- anything which uses autoscaling should already be turning itself off when not in use.

This behaviour is opt-in; the default is to leave services running 24/7.
