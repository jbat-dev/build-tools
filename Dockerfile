FROM alpine:latest
LABEL maintainer "shunichitakagi <shunichi_takagi@jbat.co.jp>"

RUN apk add --no-cache bash curl git openssh docker go python musl-dev

RUN export GOPATH=/root/go
RUN export PATH=$PATH:$GOPATH/bin
RUN go get gopkg.in/mikefarah/yq.v2

## Install pip & awscli
RUN curl https://bootstrap.pypa.io/get-pip.py | python
RUN pip install awscli