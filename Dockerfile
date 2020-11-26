FROM registry.timmertech.nl/docker/alpine-base:3.12

ARG BUILD_DATE
ARG VCS_REF
ARG PGV
ARG PGV_SHORT

LABEL \
    maintainer="G.J.R. Timmer <gjr.timmer@gmail.com>" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name=alpine-postgresql \
    org.label-schema.vendor=timmertech.nl \
    org.label-schema.url="https://gitlab.timmertech.nl/docker/alpine-postgresql" \
    org.label-schema.vcs-url="https://gitlab.timmertech.nl/docker/alpine-postgresql.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.alpinelinux.version=3.12 \
    nl.timmertech.license=MIT \
    org.postgresql.version=${PGV}

ENV LANG=en_US.utf8 \
    MUSL_LOCPATH=en_US.utf8 \
    PG_VERSION=${PGV} \
    PG_HOME=/var/lib/postgresql \
    PG_LOGDIR=/var/log/postgresql \
    PG_RUNDIR=/var/run/postgresql \
    PG_CERTDIR=/etc/postgresql/certs

ENV PG_DATADIR=${PG_HOME}/${PGV_SHORT}/main

RUN echo '@community http://dl-cdn.alpinelinux.org/alpine/v3.11/community' >> /etc/apk/repositories && \
    echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk upgrade --update --no-cache && \
    apk add --update --no-cache \
    acl \
    bash \
    ca-certificates \
    shadow \
    sudo \
    tzdata \
    postgresql=${PG_VERSION}-r0 \
    postgresql-plperl=${PG_VERSION}-r0 \
    postgresql-plperl-contrib=${PG_VERSION}-r0 \
    postgresql-plpython3=${PG_VERSION}-r0 \
    postgresql-plpython3-contrib=${PG_VERSION}-r0 \
    postgresql-pltcl=${PG_VERSION}-r0 \
    postgresql-contrib=${PG_VERSION}-r0 \
    pgtcl \
    pg_cron@testing \
    check_postgres@community && \
    echo "postgres ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/postgres && \
    chmod 600 /etc/sudoers.d/postgres && \
    sync

COPY rootfs/ /

HEALTHCHECK --interval=10s --timeout=5s --start-period=60s --retries=3 CMD [ "pg_isready",  "-U",  "postgres" ]

EXPOSE 5432/tcp

WORKDIR ${PG_HOME}

VOLUME ["${PG_HOME}", "${PG_CERTDIR}", "${PG_LOGDIR}", "${PG_RUNDIR}"]
