RELEASE_TYPE: minor

This change means that we access/reference secrets directly in Secrets Manager, rather than by using the Parameter Store integration.

Whilst this is more verbose, it means that consumers can directly reference specific keys within secrets that are JSON objects - as this is a feature of Secrets Manager, not parameter store.
