FROM registry.timmertech.nl/docker/alpine-base:latest
MAINTAINER G.J.R. Timmer <gjr.timmer@gmail.com>

ARG PG_VERSION=9.6.0

ENV LANG=en_US.utf8 \
	PG_USER=postgres \
	PG_DATABASE=postgres \
	PG_HOME=/var/lib/postgresql \
	PG_LOGDIR=/var/log/postgresql \
	PG_RUNDIR=/var/run/postgresql \
	PG_CERTDIR=/etc/postgresql/certs

ENV PG_DATADIR=${PG_HOME}/${PG_VERSION}/main \
	MUSL_LOCPATH=${LANG}
	
RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories && \
	apk add --update --no-cache \
		acl \
		bash \
		postgresql@edge>=${PG_VERSION} \
		postgresql-client@edge>=${PG_VERSION} \
		postgresql-contrib>=${PG_VERSION}

EXPOSE 5432/tcp

WORKDIR ${PG_HOME}

VOLUME ["${PG_HOME}", "${PG_LOGDIR}", "${PG_RUNDIR}"]
