FROM registry.timmertech.nl/docker/alpine-base:latest
MAINTAINER G.J.R. Timmer <gjr.timmer@gmail.com>

ENV LANG=en_US.utf8 \
	MUSL_LOCPATH=en_US.utf8

ENV PG_DATADIR=${PG_HOME}/${PG_VERSION}/main
	
RUN echo 'http://pkgs.timmertech.nl/main' >> /etc/apk/repositories && \
	echo 'http://pkgs.timmertech.nl/testing' >> /etc/apk/repositories && \
	apk add --update --no-cache \
		acl \
		bash \
		shadow \
		postgresql \
		postgresql-cron \
		postgresql-plperl \
		postgresql-plpython \
		postgresql-pltcl
		
EXPOSE 5432/tcp
