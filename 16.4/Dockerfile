FROM debian:bookworm-slim
MAINTAINER Agrista <webmaster@agrista.com>

LABEL org.opencontainers.image.source=https://github.com/agrista/docker-odoo

# Define build constants
ENV GIT_BRANCH=saas-16.4 \
  PYTHON_BIN=python3 \
  SERVICE_BIN=odoo-bin


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
    libpq-dev \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
    node-less \
    npm \
    python3-cachetools \
    python3-cerberus \
    python3-ldap \
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
    && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb \
    && echo 'ea8277df4297afc507c61122f3c349af142f31e5 wkhtmltox.deb' | sha1sum -c - \
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

# Create the odoo user
RUN useradd --create-home --home-dir /opt/odoo --no-log-init odoo

# Switch to user odoo to create the folders mapped with volumes, else the
# corresponding folders will be created by root on the host
USER odoo

# If the folders are created with "RUN mkdir" command, they will belong to root
# instead of odoo! Hence the "RUN /bin/bash -c" trick.
RUN /bin/bash -c "mkdir -p /opt/odoo/{etc,sources/odoo,addons,data,ssh}"

# Add Odoo sources and remove .git folder in order to reduce image size
WORKDIR /opt/odoo/sources
RUN git clone --depth=1 https://github.com/odoo/odoo.git -b $GIT_BRANCH \
  && rm -rf odoo/.git

User 0

RUN pip3 install --break-system-packages --upgrade pip

# Install Odoo python dependencies
ADD requirements.txt /opt/odoo/requirements.txt
RUN pip3 install --break-system-packages -r /opt/odoo/requirements.txt

# Install PIP libraries
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
    # git+https://github.com/contagra/contagra-api-python.git@main \

RUN pip3 install --break-system-packages --ignore-installed XlsxWriter==1.1.2

COPY wait-for-psql.py /usr/local/bin/wait-for-psql.py
