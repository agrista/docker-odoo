FROM debian:bookworm-slim

LABEL org.opencontainers.image.source=https://github.com/agrista/docker-odoo

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    dirmngr \
    fonts-noto-cjk \
    git \
    gnupg \
    libssl-dev \
    node-less \
    npm \
    python3-cachetools \
    python3-cerberus \
    python3-num2words \
    python3-pdfminer \
    python3-pip \
    python3-phonenumbers \
    python3-pyldap \
    python3-qrcode \
    python3-renderpm \
    python3-setuptools \
    python3-slugify \
    python3-simplejson \
    python3-vobject \
    python3-watchdog \
    python3-xlrd \
    python3-xlwt \
    xz-utils \
    # Install libssl1.1. Required by wkhtml2pdf. Possibel move to https://github.com/acsone/kwkhtmltopdf
    && curl -o libssl1.1.deb -sSL http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && apt-get -y install --no-install-recommends ./libssl1.1.deb \
    # Install wkhtmltopdf
    if [ -z "${TARGETARCH}" ]; then \
        TARGETARCH="$(dpkg --print-architecture)"; \
    fi; \
    WKHTMLTOPDF_ARCH=${TARGETARCH} && \
    case ${TARGETARCH} in \
    "amd64") WKHTMLTOPDF_ARCH=amd64 && WKHTMLTOPDF_SHA=967390a759707337b46d1c02452e2bb6b2dc6d59  ;; \
    "arm64")  WKHTMLTOPDF_SHA=90f6e69896d51ef77339d3f3a20f8582bdf496cc  ;; \
    "ppc64le" | "ppc64el") WKHTMLTOPDF_ARCH=ppc64el && WKHTMLTOPDF_SHA=5312d7d34a25b321282929df82e3574319aed25c  ;; \
    esac \
    && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_${WKHTMLTOPDF_ARCH}.deb \
    && echo ${WKHTMLTOPDF_SHA} wkhtmltox.deb | sha1sum -c - \
    && apt-get install -y --no-install-recommends ./wkhtmltox.deb \
    && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

    # install latest postgresql-client
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
    && GNUPGHOME="$(mktemp -d)" \
    && export GNUPGHOME \
    && repokey='B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8' \
    && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${repokey}" \
    && gpg --batch --armor --export "${repokey}" > /etc/apt/trusted.gpg.d/pgdg.gpg.asc \
    && gpgconf --kill all \
    && rm -rf "$GNUPGHOME" \
    && apt-get update  \
    && apt-get install --no-install-recommends -y postgresql-client \
    && rm -f /etc/apt/sources.list.d/pgdg.list \
    && rm -rf /var/lib/apt/lists/*

# Install rtlcss (on Debian buster)
RUN set -x; \
    npm install -g rtlcss

# Install Odoo
ENV ODOO_VERSION 16.0
ARG ODOO_RELEASE=20231024
ARG ODOO_SHA=8f81d6ff0fe4f9bc5a63cdeccb7006a7fc98f134
RUN curl -o odoo.deb -sSL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
    && echo "${ODOO_SHA} odoo.deb" | sha1sum -c - \
    && apt-get update \
    && apt-get -y install --no-install-recommends ./odoo.deb \
    && rm -rf /var/lib/apt/lists/* odoo.deb

# Install PIP libraries
RUN pip3 install --break-system-packages --upgrade pip
RUN pip3 install --break-system-packages \
    a2wsgi \
    apispec \
    apispec>=4.0.0 \
    boto3==1.18.25 \
    fastapi \
    fastapi_camelcase \
    geojson \
    Elasticsearch \
    graphene \
    graphql_server \
    graphql-server-core \
    jwcrypto \
    jsondiff \
    locomotivecms \
    marshmallow \
    marshmallow-objects>=2.0.0 \
    numpy \
    numpy-financial \
    odoo-test-helper \
    openpyxl \
    parse-accept-language \
    phonenumbers \
    pydantic==1.10.11 \
    pyfcm \
    PyJWT \
    pyquerystring \
    python-json-logger==0.1.5 \
    python_jwt \
    python-magic \
    python-multipart \
    python-slugify \
    PyYAML \
    redis==2.10.5 \
    requests_mock \
    slugify \
    shapely \
    statsd==3.2.1 \
    ujson \
    unidecode \
    # XlsxWriter==1.1.2 \
    validators==0.18.2 \
    git+https://github.com/OCA/openupgradelib.git@master#egg=openupgradelib
    # git+https://github.com/contagra/contagra-api-python.git@main

RUN pip3 install --break-system-packages --ignore-installed XlsxWriter==1.1.2
RUN pip3 install --break-system-packages --ignore-installed Werkzeug==2.0.2 --force-reinstall

COPY wait-for-psql.py /usr/local/bin/wait-for-psql.py
