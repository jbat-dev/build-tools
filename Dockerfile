FROM alpine:latest
LABEL maintainer "shunichitakagi <shunichi_takagi@jbat.co.jp>"

## Setup environments
ENV GOPATH  /root/go
ENV PATH    $PATH:$GOPATH/bin

## Install by apk
RUN apk add --no-cache bash curl git openssh docker go python musl-dev

## Install yq
RUN go get gopkg.in/mikefarah/yq.v2
RUN ln -s $(which yq.v2) /usr/bin/yq

## Install pip & awscli
RUN curl https://bootstrap.pypa.io/get-pip.py | python
RUN pip install awscli