FROM ubuntu:18.04

LABEL maintainer="zato <tato.zimmermann@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

ENV USERNAME=transmissionuser
ENV PASSWORD=tpass

RUN apt-get -qq update && apt-get install -qq -y apt-utils >/dev/null && apt-get full-upgrade -qq -y >/dev/null && \
    apt-get install -y -qq software-properties-common jq >/dev/null

RUN add-apt-repository -y ppa:transmissionbt/ppa && \
    apt-get update -qq >/dev/null && \
	apt-get install -qq -y transmission-cli transmission-common transmission-daemon >/dev/null

RUN apt-get -qq clean >/dev/null && apt-get -qq -y autoremove >/dev/null && rm -rf /var/lib/apt/lists/*

RUN service transmission-daemon start && service transmission-daemon stop

RUN cd /var/lib/transmission-daemon/info && \ 
    jq '."rpc-host-whitelist-enabled" = false' settings.json > tmp.json && mv tmp.json settings.json && \
    jq '."rpc-username" = "$ENV.USERNAME"' settings.json > tmp.json && mv tmp.json settings.json && \
    jq '."rpc-password" = "$ENV.PASSWORD"' settings.json > tmp.json && mv tmp.json settings.json && \
    jq '.' settings.json

VOLUME ["/var/lib/transmission-daemon"]

EXPOSE 9091 51413/tcp 51413/udp
