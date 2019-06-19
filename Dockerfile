FROM circleci/openjdk:8-jdk
LABEL maintainer="jbat-dev"

### Install by apk
RUN sudo apt-get update
RUN sudo apt-get install bash curl git docker python musl-dev zip

### Install go
RUN sudo curl -o go.tar.gz https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz \
    && sudo tar -C /usr/local -xzf go.tar.gz

ENV GOHOME /usr/local/go
ENV PATH    $PATH:$GOHOME/bin:~/bin

### install yq
RUN go get gopkg.in/mikefarah/yq.v2
RUN sudo ln -s $(which yq.v2) /usr/bin/yq

## Install pip & awscli, slack-cli
RUN sudo apt-get install python-pip
RUN sudo pip install awscli
RUN sudo pip install slack-cli

## Install iam authenticator
RUN sudo curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator \
    && sudo chmod +x ./aws-iam-authenticator \
    && sudo mv ./aws-iam-authenticator /usr/local/bin/

RUN sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && sudo chmod +x kubectl \
    && sudo mv kubectl /usr/local/bin/
