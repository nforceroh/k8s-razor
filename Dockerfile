FROM ghcr.io/nforceroh/k8s-alpine-baseimage:latest

ARG \
  BUILD_DATE=now \
  VERSION=unknown

LABEL \
  maintainer="Sylvain Martin (sylvain@nforcer.com)"

ENV \
  RAZORFY_DEBUG=1 \
  RAZORFY_MAXTHREADS=50 \
  RAZORFY_BINDADDRESS=0.0.0.0 \
  RAZORFY_BINDPORT=11342 

### Install Dependencies
RUN apk upgrade --no-cache \
  && apk add --no-cache razor perl-io-socket-ip \
  && rm -rf /var/cache/apk/* /usr/src/*

### Add Files
ADD --chown=abc:abc --chmod=755 https://raw.githubusercontent.com/HeinleinSupport/razorfy/refs/heads/master/razorfy.pl /app/razorfy.pl
ADD --chown=abc:abc --chmod=644 https://raw.githubusercontent.com/HeinleinSupport/razorfy/refs/heads/master/razorfy.conf /etc/razorfy.conf


COPY --chmod=755 /etc/s6-overlay /etc/s6-overlay

EXPOSE 11342

ENTRYPOINT [ "/init" ]
