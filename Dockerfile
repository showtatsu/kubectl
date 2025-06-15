FROM alpine:3.17
MAINTAINER Serhiy Mitrovtsiy <mitrovtsiy@ukr.net>

ARG TARGETPLATFORM
ARG KUBE_VERSION="v1.33.1"

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then ARCHITECTURE=arm; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=amd64; fi && \
    apk add --no-cache --update openssl curl ca-certificates jq && \
    curl -L https://dl.k8s.io/release/$KUBE_VERSION/bin/linux/$ARCHITECTURE/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh
COPY scripts /scripts
RUN chmod +x /entrypoint.sh /scripts/*.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cluster-info"]
