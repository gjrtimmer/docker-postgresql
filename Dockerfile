FROM registry.timmertech.nl/docker/alpine-base:latest
MAINTAINER G.J.R. Timmer <gjr.timmer@gmail.com>

ARG PG_VERSION=9.6.0

RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories && \
	apk add --update --no-cache \
		acl \
		bash \
		postgresql@edge>=${PG_VERSION} \
		postgresql-client@edge>=${PG_VERSION} \
		postgresql-contrib>=${PG_VERSION}

EXPOSE 5432/tcp
