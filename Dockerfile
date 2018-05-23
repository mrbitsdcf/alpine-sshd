FROM alpine:3.6
LABEL "Maintainer"="MrBiTs"
LABEL "e-mail"="mrbits.dcf@gmail.com"
LABEL "version"="0.3"

RUN apk add --no-cache openssh curl \
    && cp /etc/ssh/sshd_config /sshd_config.orig

VOLUME /etc/ssh

COPY entrypoint.sh /

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
