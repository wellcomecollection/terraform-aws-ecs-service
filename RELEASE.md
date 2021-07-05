RELEASE_TYPE: patch

This fixes two bugs:

-   You couldn't create an ECS task that read secrets from Secrets Manager if the secrets didn't exist yet (e.g. if they were being created as part of the same Terraform configuration).

    Now you can configure secrets that don't exist yet as long as you're not looking up a specific key within that secret.

-   Fix a bug where service namespace discovery wasn't being enabled/disabled correctly.
