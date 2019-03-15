FROM alpine:latest
LABEL maintainer "shunichitakagi <shunichi_takagi@jbat.co.jp>"

# Install from apk
RUN apk add --no-cache curl git docker go musl-dev

# Setup Go environment
RUN export GOPATH=/root/go
RUN export PATH=$PATH:$GOPATH/bin

# Install yq
RUN go get gopkg.in/mikefarah/yq.v2