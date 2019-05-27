FROM alpine:latest
LABEL maintainer "shunichitakagi <shunichi_takagi@jbat.co.jp>"

## Setup environments
ENV GOPATH  /root/go
ENV PATH    $PATH:$GOPATH/bin

## Install by apk
RUN apk add --no-cache bash curl git openssh docker go python musl-dev zip

## Install yq
RUN go get gopkg.in/mikefarah/yq.v2
RUN ln -s $(which yq.v2) /usr/bin/yq

## Install pip & awscli, slack-cli
RUN curl https://bootstrap.pypa.io/get-pip.py | python
RUN pip install awscli
RUN pip install slack-cli

# Install iam authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator \
    && chmod +x ./aws-iam-authenticator \
    && mv ./aws-iam-authenticator /usr/local/bin/
