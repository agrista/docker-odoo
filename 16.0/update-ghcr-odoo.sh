#!/bin/bash
docker build -t agrista/odoo:16.0-bookworm -t ghcr.io/agrista/odoo:16.0-bookworm .
docker push ghcr.io/agrista/odoo:16.0-bookworm
