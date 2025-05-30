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
  && addgroup razor 2>/dev/null \
  && adduser -D --gecos "razor antispam" --ingroup razor razor 2>/dev/null \
  && mkdir /home/razor/.razor && chown razor:razor /home/razor/.razor \
  && rm -rf /var/cache/apk/* /usr/src/*

### Add Files
ADD --chmod=755 /content/etc/s6-overlay /etc/s6-overlay
ADD --chown=razor:razor --chmod=755 /content/razorfy/razorfy.pl /home/razor/razorfy.pl
ADD --chown=razor:razor --chmod=644 /content/razorfy/razorfy.conf /home/razor/razorfy.conf
ADD --chown=razor:razor --chmod=644 /content/razorfy/razor-agent.conf /home/razor/.razor/razorfy-agent.conf

EXPOSE 11342

ENTRYPOINT [ "/init" ]
