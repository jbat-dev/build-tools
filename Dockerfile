FROM alpine:latest
LABEL maintainer "shunichitakagi <shunichi_takagi@jbat.co.jp>"

RUN apk add --no-cache curl git docker go musl-dev
RUN apk add --no-cache python3

RUN export GOPATH=/root/go
RUN export PATH=$PATH:$GOPATH/bin
RUN go get gopkg.in/mikefarah/yq.v2

RUN apk add --no-cache aws-cli