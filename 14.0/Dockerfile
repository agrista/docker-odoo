FROM debian:buster-slim

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
    npm \
    python3-cachetools \
    python3-cerberus \
    python3-num2words \
    python3-pdfminer \
    python3-pip \
    python3-pyldap \
    python3-qrcode \
    python3-renderpm \
    python3-setuptools \
    python3-simplejson \
    python3-vobject \
    python3-watchdog \
    python3-xlrd \
    python3-xlwt \
    xz-utils \
    && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb \
    && echo 'ea8277df4297afc507c61122f3c349af142f31e5 wkhtmltox.deb' | sha1sum -c - \
    && dpkg --force-depends -i wkhtmltox.deb\
    && apt-get -y install -f --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# install latest postgresql-client
RUN set -x; \
    echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' > etc/apt/sources.list.d/pgdg.list \
    && export GNUPGHOME="$(mktemp -d)" \
    && repokey='B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8' \
    && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${repokey}" \
    && gpg --armor --export "${repokey}" | apt-key add - \
    && gpgconf --kill all \
    && rm -rf "$GNUPGHOME" \
    && apt-get update  \
    && apt-get install -y postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install rtlcss (on Debian buster)
RUN set -x; \
    npm install -g less@3.10.3 \
    && npm install -g rtlcss

# Install Odoo
ENV ODOO_VERSION 14.0
ARG ODOO_RELEASE=20220110
ARG ODOO_SHA=a32b3d766e45320a0092b40b18728b326da1210c
RUN curl -o odoo.deb -sSL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
    && echo "${ODOO_SHA} odoo.deb" | sha1sum -c - \
    && apt-get update \
    && apt-get -y install --no-install-recommends ./odoo.deb \
    && rm -rf /var/lib/apt/lists/* odoo.deb

# Install PIP libraries
RUN pip3 install --upgrade pip
RUN pip3 install \
    apispec \
    apispec>=4.0.0 \
    boto3==1.18.25 \
    geojson \
    Elasticsearch \
    graphene==2.1.9 \
    graphql-server-core \
    jwcrypto \
    jsondiff \
    locomotivecms \
    marshmallow \
    marshmallow-objects>=2.0.0 \
    numpy \
    openpyxl \
    parse-accept-language \
    phonenumbers \
    pyfcm \
    pyquerystring \
    python-json-logger==0.1.5 \
    python-jwt \
    python-magic \
    python-slugify \
    PyYAML \
    redis==2.10.5 \
    requests_mock \
    slugify \
    shapely \
    statsd==3.2.1 \
    unidecode \
    XlsxWriter==1.1.2 \
    validators==0.18.2 \
    git+https://github.com/OCA/openupgradelib.git@master#egg=openupgradelib

COPY wait-for-psql.py /usr/local/bin/wait-for-psql.py
