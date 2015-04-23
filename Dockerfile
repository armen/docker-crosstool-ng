FROM debian:7.8
MAINTAINER Armen Baghumian <armen@OpenSourceClub.org>

ENV CT_VERSION 1.20.0

WORKDIR	/root

# Install dependencies.
RUN	apt-get update && DEBIAN_FRONTEND=noninteractive\
	apt-get install -y build-essential gperf bison flex texinfo wget gawk libtool automake libncurses5-dev cvs

# Download and compile crosstool-NG.
RUN	wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CT_VERSION}.tar.bz2 2>&1 &&\
	tar xfj crosstool-ng-${CT_VERSION}.tar.bz2 &&\
	cd crosstool-ng-${CT_VERSION} &&\
	./configure && make && make install &&\
	rm -rf ../crosstool-ng-${CT_VERSION}.tar.bz2

# Internal wiring.
RUN	mkdir crosstool-NG /etc/crosstool-ng &&\
	ln -s /root/crosstool-NG/.config /etc/crosstool-ng/crosstool-ng.conf

COPY	in/toolchain-build	/usr/local/bin/
COPY	in/crosstool-configure	/usr/local/bin/
COPY	in/crosstool-ng.conf	/root/crosstool-NG/.config
