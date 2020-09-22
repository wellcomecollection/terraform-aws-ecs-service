FROM python:3

ARG COMMAND
VOLUME /workdir
WORKDIR /workdir

ADD . /workdir

ENV REPO_URL=git@github.com:wellcomecollection/terraform-aws-ecs-service.git

ENTRYPOINT python3 /workdir/tf_tooling.py