FROM registry.timmertech.nl/docker/alpine-base:latest
MAINTAINER G.J.R. Timmer <gjr.timmer@gmail.com>

ARG PG_PKG_VERSION=9.6.0-r1

ENV LANG=en_US.utf8 \
	MUSL_LOCPATH=en_US.utf8 \
	PG_VERSION=9.6 \
	PG_HOME=/var/lib/postgresql \
	PG_LOGDIR=/var/log/postgresql \
	PG_RUNDIR=/var/run/postgresql

ENV PG_DATADIR=${PG_HOME}/${PG_VERSION}/main
	
RUN echo 'ttp://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories && \
	echo 'http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
	apk add --update --no-cache \
		acl \
		bash \
		shadow \
		postgresql=${PG_PKG_VERSION} \
		postgresql-client=${PG_PKG_VERSION} \
		postgresql-contrib=${PG_PKG_VERSION}
		
COPY rootfs/ /
		
EXPOSE 5432/tcp

WORKDIR ${PG_HOME}

VOLUME ["${PG_HOME}", "${PG_LOGDIR}", "${PG_RUNDIR}"]
