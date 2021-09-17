RELEASE_TYPE: minor

This change adds deployment circuit breaker configuration to our ECS module and enables it by default.

Enabling the "deployment circuit breaker", turns on detection of repeated failed attempts to start tasks as part of an ECS deployment and will "cancel" a deployment if a particular threshold for failed tasks is met.
