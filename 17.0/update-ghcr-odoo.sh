#!/bin/bash
docker build -t agrista/odoo:17.0-jammy -t ghcr.io/agrista/odoo:17.0-jammy .
docker push ghcr.io/agrista/odoo:17.0-jammy
