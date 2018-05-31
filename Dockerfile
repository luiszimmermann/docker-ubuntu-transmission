FROM ubuntu:18.04

MAINTAINER zato <tato.zimmermann@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y apt-utils && apt-get full-upgrade -y && \
    apt-get install -y software-properties-common

RUN add-apt-repository -y ppa:transmissionbt/ppa && \
    apt-get update && \
	apt-get install -y transmission-cli transmission-common transmission-daemon

RUN service transmission-daemon start
RUN service transmission-daemon stop


RUN service transmission-daemon start
	
VOLUME ["/var/lib/transmission-daemon"]

EXPOSE 9091 51413/tcp 51413/udp
