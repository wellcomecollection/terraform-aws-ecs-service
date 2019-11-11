# terraform-aws-ecs-single-container

[![Build Status](https://travis-ci.org/wellcomecollection/terraform-aws-ecs-service.svg?branch=master)](https://travis-ci.org/wellcomecollection/terraform-aws-ecs-service)

This repo contains some modules that are useful for creating an ECS task.

In particular, you should look at:

*   `task_definition/single_container` -- creates an ECS task definition with a single container (for example, a queue-backed worked in one of our pipelines)

*   `task_definition/container_with_sidecar` -- creates an ECS task definition with two containers: an "app" and a "sidecar" (for example, an API app with an nginx proxy container)

*   `service` -- creates an ECS service

This repo does not currently do anything around autoscaling of ECS services or tasks.
