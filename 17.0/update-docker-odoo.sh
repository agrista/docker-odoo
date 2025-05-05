#!/bin/bash
docker build -t contagra/odoo:16.0-bookworm .
docker push contagra/odoo:16.0-bookworm