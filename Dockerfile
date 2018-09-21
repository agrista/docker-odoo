FROM debian:stable
LABEL version="1.0" \
      maintainer="Agrista <info@agrista.com>" \
      description="Odoo docker image for the Agrisat SaaS service"

WORKDIR /srv/odoo

COPY requirements.txt /srv/odoo/

RUN mkdir local bin \
    && \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends\
         fontconfig \
         libfreetype6 \
         libx11-6 \
         libxext6 \
         libxrender1 \
         node-clean-css \
         node-less \
         python3-pip \
         virtualenv \
         python3 \
         wget \
         xfonts-75dpi \
         xfonts-base \
         xz-utils \
         zlib1g \
         gcc \
         libevent-dev \
         libjpeg-dev \
         libldap2-dev \
         libpng-dev \
         libpq-dev \
         libsasl2-dev \
         libxml2-dev \
         libxslt1-dev \
         python3-dev \
         python3-setuptools \
    && \
    pip3 install --no-cache-dir -r requirements.txt \
    && \
    apt-get remove --purge --autoremove -y \
         gcc \
         g++ \
    && \
    wget -qO wkhtmltox.tar.xz https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && \
    tar -xf wkhtmltox.tar.xz \
    && \
    install wkhtmltox/lib/* /usr/lib \
    && \
    install wkhtmltox/bin/* /usr/bin \
    && \
    rm -rf wkhtmltox wkhtmltox.tar.xz \
    && \
    apt-get remove --purge -y \
         libevent-dev \
         libjpeg-dev \
         libldap2-dev \
         libpng-dev \
         libpq-dev \
         libsasl2-dev \
         libxml2-dev \
         libxslt1-dev \
         python3-dev \
         wget \
         xz-utils\
    && \
    apt-get clean \
    ;
