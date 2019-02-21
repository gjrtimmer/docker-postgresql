FROM registry.timmertech.nl/docker/alpine-base

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

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories && \
    echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk upgrade --update --no-cache && \
    apk add --update --no-cache \
    acl \
    bash \
    ca-certificates \
    shadow \
    sudo \
    tzdata \
    postgresql@edge=${PG_VERSION}-r0 \
    postgresql-plperl@edge=${PG_VERSION}-r0 \
    postgresql-plperl-contrib@edge=${PG_VERSION}-r0 \
    postgresql-plpython3@edge=${PG_VERSION}-r0 \
    postgresql-plpython3-contrib@edge=${PG_VERSION}-r0 \
    postgresql-pltcl@edge=${PG_VERSION}-r0 \
    postgresql-contrib@edge=${PG_VERSION}-r0 \
    pgtcl \
    pg_cron@testing \
    check_postgres && \
    echo "postgres ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/postgres && \
    chmod 600 /etc/sudoers.d/postgres && \
    sync

COPY rootfs/ /

HEALTHCHECK --interval=10s --timeout=5s --start-period=60s --retries=3 CMD [ "pg_isready",  "-U",  "postgres" ]

EXPOSE 5432/tcp

WORKDIR ${PG_HOME}

VOLUME ["${PG_HOME}", "${PG_CERTDIR}", "${PG_LOGDIR}", "${PG_RUNDIR}"]
