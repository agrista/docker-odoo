#!/bin/bash
docker build -t registry.fly.io/agrista-odoo:17.0-jammy .
flyctl auth docker
docker push registry.fly.io/agrista-odoo:17.0-jammy