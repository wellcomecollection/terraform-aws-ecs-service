# terraform-aws-ecs-service

[![Build status](https://badge.buildkite.com/c76499108cb00f2cb853fe8e7bac20158fea3df4dd6bc2da8b.svg?branch=main)](https://buildkite.com/wellcomecollection/terraform-module-terraform-aws-ecs-service)

This repo contains the template modules for building ECS services on the Wellcome Collection digital platform.

## Developing

If you add a feature to these modules, please update and test the [example module](/example) which will create a dummy service in the developer VPC space within the platform account.

### Release documentation

If you are submitting a PR with a change you will need to include a `RELEASE.md` file at the repo root with the format: 

```
RELEASE_TYPE: patch|minor|major

Description of the changes in this release.
```
