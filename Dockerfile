# Alpine version will define the postgresql version to be used
ARG ALPINE_VERSION

FROM ghcr.io/linuxserver/baseimage-alpine:${ALPINE_VERSION} as postgresql

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk upgrade --update --no-cache && \
    apk add --update --no-cache \
    acl \
    bash \
    ca-certificates \
    coreutils \
    findutils \
    shadow \
    sudo \
    tzdata \
    postgresql \
    postgresql-plperl \
    postgresql-plperl-contrib \
    postgresql-plpython3 \
    postgresql-plpython3-contrib \
    postgresql-pltcl \
    postgresql-contrib \
    postgresql-pg_cron \
    pgtcl \
    check_postgres && \
    echo "postgres ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/postgres && \
    chmod 600 /etc/sudoers.d/postgres && \
    sync


# Runtime container
FROM postgresql as runtime

ARG BUILD_DATE
ARG CI_PROJECT_NAME
ARG CI_PROJECT_URL
ARG VCS_REF
ARG DOCKER_IMAGE
ARG ALPINE_VERSION

ENV LANG='en_US.utf8' \
    MUSL_LOCPATH='en_US.utf8' \
    HOME=/config \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

HEALTHCHECK --interval=10s --timeout=5s --start-period=60s --retries=3 CMD [ "pg_isready",  "-U",  "postgres" ]

EXPOSE 5432/tcp

WORKDIR ${HOME}
VOLUME [ "${HOME}" ]

COPY rootfs/ /

LABEL \
    maintainer="G.J.R. Timmer <gjr.timmer@gmail.com>" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name=${CI_PROJECT_NAME} \
    org.label-schema.url="${CI_PROJECT_URL}" \
    org.label-schema.vcs-url="${CI_PROJECT_URL}.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.docker.image="${DOCKER_IMAGE}" \
    org.label-schema.alpine-version="${ALPINE_VERSION}" \
    org.label-schema.license=MIT


# EOF