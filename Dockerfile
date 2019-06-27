FROM alpine:latest
LABEL maintainer "shunichitakagi <shunichi_takagi@jbat.co.jp>"

## Setup environments
ENV GOPATH  /root/go
ENV PATH    $PATH:$GOPATH/bin

## Install by apk
RUN apk add --no-cache bash curl git openssh docker go python musl-dev zip terraform

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

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Install Helm
RUN curl -o helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz \
    && tar -zxvf helm.tar.gz \
    && cp linux-amd64/helm /usr/local/bin/helm

RUN curl -o terraform.zip https://releases.hashicorp.com/terraform/0.12.2/terraform_0.12.2_linux_amd64.zip \
    && unzip terraform.zip \
    && chmod +x terraform \
    && mv terraform /usr/local/bin/


# install hugo
#RUN curl -kL -o hugo.tar.gz https://github.com/gohugoio/hugo/archive/v0.55.6.tar.gz \
#    && tar -xvzf hugo.tar.gz \
#    && cd hugo-0.55.6 \
#    && go install
RUN curl -kL -o hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.17/hugo_0.17_Linux-64bit.tar.gz \
    && tar -zxvf hugo.tar.gz \
    && cd hugo_0.17_linux_amd64 \
    && mv hugo_0.17_linux_amd64 /usr/local/bin/hugo \
    && hugo version

# install pandoc
ENV PANDOC_VERSION 2.7.2
ENV PANDOC_DOWNLOAD_URL https://github.com/jgm/pandoc/archive/$PANDOC_VERSION.tar.gz
ENV PANDOC_ROOT /usr/local/pandoc

RUN apk add --no-cache \
    gmp \
    libffi \
 && apk add --no-cache --virtual build-dependencies \
    --repository "http://nl.alpinelinux.org/alpine/edge/community" \
    ghc \
    cabal \
    linux-headers \
    musl-dev \
    zlib-dev \
    curl \
 && mkdir -p /pandoc-build && cd /pandoc-build \
 && curl -fsSL "$PANDOC_DOWNLOAD_URL" -o pandoc.tar.gz \
 && tar -xzf pandoc.tar.gz && rm -f pandoc.tar.gz \
 && ( cd pandoc-$PANDOC_VERSION && cabal update && cabal install --only-dependencies \
    && cabal configure --prefix=$PANDOC_ROOT \
    && cabal build \
    && cabal copy \
    && cd .. ) \
 && rm -Rf pandoc-$PANDOC_VERSION/ \
 && apk del --purge build-dependencies \
 && rm -Rf /root/.cabal/ /root/.ghc/ \
 && cd / && rm -Rf /pandoc-build \
 && mv $PANDOC_ROOT/bin/* /usr/local/bin
 && pandoc -v

# nodejs
RUN apk add --no-cache nodejs
RUN apk add --no-cache npm