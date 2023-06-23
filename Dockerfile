FROM python:3

ARG COMMAND
VOLUME /workdir
WORKDIR /workdir

ADD . /workdir

# These instructions are taken from the Terraform docs for installing
# the CLI, retrieved 23 June 2023
#
# See https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
RUN apt-get update && apt-get install -y gnupg software-properties-common
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update && apt-get install -y terraform

ENTRYPOINT ["/workdir/scripts/tooling.py"]