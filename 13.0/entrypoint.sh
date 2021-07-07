#!/bin/bash

set -e

# set the postgres database host, port, user and password according to the environment
# and pass them as arguments to the odoo process if not present in the config file
: ${HOST:=${ODOO_DB_HOST:='db'}}
: ${PORT:=${ODOO_DB_PORT:=5432}}
: ${USER:=${ODOO_DB_USER:='marketplace'}}}
: ${PASSWORD:=${ODOO_DB_PASSWORD:='marketplace'}}}
: ${DATABASE:=${ODOO_DATABASE:='marketplace'}}
DB_ARGS=()
function check_config() {
  param="$1"
  value="$2"
  if ! grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC"; then
    DB_ARGS+=("--${param}")
      DB_ARGS+=("${value}")
  fi
}
check_config "db_host" "$HOST"
check_config "db_port" "$PORT"
check_config "db_user" "$USER"
check_config "db_password" "$PASSWORD"
check_config "database" "$DATABASE"

case "$1" in
-- | odoo)
  shift
  if [[ "$1" == "scaffold" ]]; then
    exec odoo "$@"
  else
    exec odoo "$@" "${DB_ARGS[@]}"
  fi
  ;;
-*)
  exec odoo "$@" "${DB_ARGS[@]}"
  ;;
*)
  exec "$@"
  ;;
esac

exit 1
