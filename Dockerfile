FROM ubuntu:18.04

MAINTAINER zato <tato.zimmermann@gmail.com>

RUN apt-get update && apt-get full-upgrade -y && \
    apt-get install -y software-properties-common

RUN add-apt-repository -y ppa:transmissionbt/ppa && \
    apt-get update && \
	apt-get install -y transmission-cli transmission-common transmission-daemon