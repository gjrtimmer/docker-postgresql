FROM registry.timmertech.nl/docker/alpine-base:latest
MAINTAINER G.J.R. Timmer <gjr.timmer@gmail.com>

ARG BUILD_DATE
ARG VCS_REF
ARG PGV

LABEL \
	nl.timmertech.build-date=${BUILD_DATE} \
	nl.timmertech.name=alpine-redis \
	nl.timmertech.vendor=timmertech.nl \
	nl.timmertech.vcs-url="https://gitlab.timmertech.nl/docker/alpine-postgresql.git" \
	nl.timmertech.vcs-ref=${VCS_REF} \
	nl.timmertech.license=MIT

ENV LANG=en_US.utf8 \
	MUSL_LOCPATH=en_US.utf8 \
	PG_VERSION=${PGV} \
	PG_HOME=/var/lib/postgresql \
	PG_LOGDIR=/var/log/postgresql \
	PG_RUNDIR=/var/run/postgresql \
	PG_CERTDIR=/etc/postgresql/certs

ENV PG_DATADIR=${PG_HOME}/${PG_VERSION}/main
	
RUN echo 'http://pkgs.timmertech.nl/main' >> /etc/apk/repositories && \
	echo '@testing http://pkgs.timmertech.nl/testing' >> /etc/apk/repositories && \
	echo 'http://nl.alpinelinux.org/alpine/edge/main'  >> /etc/apk/repositories && \
	echo 'http://nl.alpinelinux.org/alpine/edge/community'  >> /etc/apk/repositories && \
	echo 'http://nl.alpinelinux.org/alpine/edge/testing'  >> /etc/apk/repositories && \
	wget -O /etc/apk/keys/gjr.timmer@gmail.com-5857d36d.rsa.pub http://pkgs.timmertech.nl/keys/gjr.timmer%40gmail.com-5857d36d.rsa.pub && \
	apk upgrade --update --no-cache && \
	apk add --update --no-cache \
		acl \
		bash \
		shadow \
		sudo \
		postgresql \
		postgresql-plperl \
		postgresql-plperl-contrib \
		postgresql-plpython3 \
		postgresql-plpython3-contrib \
		postgresql-pltcl \
		postgresql-contrib \
		pgtcl \
		pg_cron \
		check_postgres@testing \
		consul@testing && \
	echo "postgres ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/postgres && \
	chmod 600 /etc/sudoers.d/postgres && \
	sync
	
COPY rootfs/ /
		
EXPOSE 5432/tcp

WORKDIR ${PG_HOME}

VOLUME ["${PG_HOME}", "${PG_CERTDIR}", "${PG_LOGDIR}", "${PG_RUNDIR}"]
