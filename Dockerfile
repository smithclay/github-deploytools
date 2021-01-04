FROM alpine:3.7

RUN mkdir /tools
WORKDIR /tools

RUN apk add --no-cache curl
RUN apk add --no-cache jq
RUN apk add --no-cache libc6-compat

RUN wget https://github.com/cli/cli/releases/download/v1.2.0/gh_1.2.0_linux_amd64.tar.gz
RUN tar xzvf gh_1.2.0_linux_amd64.tar.gz
RUN mv gh_1.2.0_linux_amd64/bin/gh /usr/bin/gh

ADD ./deploy.sh /usr/bin/deploy-wrapper

ENTRYPOINT ["/usr/bin/deploy-wrapper"]