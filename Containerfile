# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="LimeSurvey" \
        org.opencontainers.image.description="Survey Platform" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/limesurvey" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-limesurvey/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-limesurvey.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    LIMESURVEY_VERSION="6.15.20+251021" \
    LIMESURVEY_REPO_URL="https://github.com/LimeSurvey/LimeSurvey"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    PHP_MODULE_ENABLE_FILEINFO=TRUE \
    PHP_MODULE_ENABLE_IMAP=TRUE \
    PHP_MODULE_ENABLE_LDAP=TRUE \
    PHP_MODULE_ENABLE_MBSTRING=TRUE \
    PHP_MODULE_ENABLE_SESSION=TRUE \
    PHP_MODULE_ENABLE_SIMPLEXML=TRUE \
    PHP_MODULE_ENABLE_SODIUM=TRUE \
    PHP_MODULE_ENABLE_XMLWRITER=TRUE \
    PHP_MODULE_ENABLE_ZIP=TRUE \
    IMAGE_NAME="nfrastack/limesurvey" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-limesurvey/"

RUN echo "" && \
    source /container/base/functions/container/build && \
    container_build_log image && \
    package update && \
    package upgrade && \
    php-ext prepare && \
    php-ext reset && \
    php-ext enable core && \
    mkdir -p "${NGINX_WEBROOT}" && \
    curl -SL "${LIMESURVEY_REPO_URL}"/archive/"${LIMESURVEY_VERSION}".tar.gz | tar xvfz - --strip 1 -C "${NGINX_WEBROOT}" && \
    rm -rf \
           "${NGINX_WEBROOT}"/docs \
           "${NGINX_WEBROOT}"/tests \
           "${NGINX_WEBROOT}"/*.md && \
    container_build_log add "LimeSurvey" "${LIMESURVEY_VERSION}" "${LIMESURVEY_REPO_URL}" && \
    package cleanup

COPY rootfs /
