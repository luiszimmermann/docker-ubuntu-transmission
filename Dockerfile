FROM ubuntu:18.04

LABEL maintainer="zato <tato.zimmermann@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

ENV USERNAME=transmissionuser
ENV PASSWORD=tpass

RUN apt-get -qq update && apt-get -qq  install -y apt-utils && apt-get -qq full-upgrade -y && \
    apt-get -qq install -y software-properties-common jq

RUN add-apt-repository -y ppa:transmissionbt/ppa && \
    apt-get -qq update && \
	apt-get -qq install -y transmission-cli transmission-common transmission-daemon

RUN apt-get -qq clean && apt-get -qq -y autoremove && rm -rf /var/lib/apt/lists/*

RUN service transmission-daemon start && service transmission-daemon stop

RUN cd /var/lib/transmission-daemon/info && \ 
    jq '."rpc-host-whitelist-enabled" = false' settings.json > tmp.json && mv tmp.json settings.json && \
    jq '."rpc-username" = "env.USERNAME"' settings.json > tmp.json && mv tmp.json settings.json && \
    jq '."rpc-password" = "env.PASSWORD"' settings.json > tmp.json && mv tmp.json settings.json

VOLUME ["/var/lib/transmission-daemon"]

EXPOSE 9091 51413/tcp 51413/udp
