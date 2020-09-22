FROM python:3

ARG COMMAND
VOLUME /workdir
WORKDIR /workdir

ADD . /workdir

RUN apt-get update && apt-get install -y software-properties-common

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update && apt-get install -y terraform

ENTRYPOINT ["/workdir/scripts/tooling.py"]