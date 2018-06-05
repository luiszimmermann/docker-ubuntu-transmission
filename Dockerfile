FROM ubuntu:18.04

LABEL maintainer="zato <tato.zimmermann@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y apt-utils && apt-get full-upgrade -y && \
    apt-get install -y software-properties-common jq

RUN add-apt-repository -y ppa:transmissionbt/ppa && \
    apt-get update && \
	apt-get install -y transmission-cli transmission-common transmission-daemon

RUN service transmission-daemon start && service transmission-daemon stop

RUN cd /var/lib/transmission-daemon/info && \ 
    jq '."rpc-host-whitelist-enabled" = false' settings.json && \
    jq '."rpc-username" = "transmissionuser"' settings.json && \
    jq '."rpc-password" = "tpass8794"' settings.json

RUN service transmission-daemon start

VOLUME ["/var/lib/transmission-daemon"]

EXPOSE 9091 51413/tcp 51413/udp
