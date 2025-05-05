#!/bin/bash

set -e

# set the postgres database host, port, user and password according to the environment
# and pass them as arguments to the odoo process if not present in the config file
: ${HOST:=${ODOO_DB_HOST}}
: ${PORT:=${ODOO_DB_PORT:=5432}}
: ${USER:=${ODOO_DB_USER}}
: ${PASSWORD:=${ODOO_DB_PASSWORD}}
: ${DB_NAME:=${ODOO_DB_NAME}}
: ${DB_FILTER:=${ODOO_DB_FILTER}}
: ${NO_DATABASE_LIST:=${ODOO_NO_DATABASE_LIST:=False}}
: ${WITHOUT_DEMO:=${ODOO_WITHOUT_DEMO:=True}}
: ${PROXY_MODE:=${ODOO_PROXY_MODE:=True}}
: ${WORKERS:=${ODOO_WORKERS}}
: ${LOG_LEVEL:=${ODOO_LOG_LEVEL=':INFO'}}
: ${LIMIT_TIME_CPU:=${ODOO_LIMIT_TIME_CPU:=600}}
: ${LIMIT_TIME_REAL:=${ODOO_LIMIT_TIME_REAL:=1200}}
: ${LOAD_MODULES:=${ODOO_LOAD_MODULES:='web'}}
: ${EMAIL_FROM:=${ODOO_EMAIL_FROM}}
: ${SMTP_SERVER:=${ODOO_SMTP_SERVER}}
: ${SMTP_PORT:=${ODOO_SMTP_PORT:=465}}
: ${SMTP_SSL:=${ODOO_SMTP_SSL:=True}}
: ${SMTP_USER:=${ODOO_SMTP_USER}}
: ${SMTP_PASSWORD:=${ODOO_SMTP_PASSWORD}}
: ${AWS_REGION:=${AWS_REGION}}


DB_ARGS=()
function check_config() {
  param="$1"
  value="$2"
  if ! grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC"; then
    if [ "${value}" == "True" ]; then
      DB_ARGS+=("--${param}")
    else
      if ! [ "${value}" == "False" ]; then
        DB_ARGS+=("--${param}")
        DB_ARGS+=("${value}")
      fi
    fi
  fi
}

check_config "db_host" "$HOST"
check_config "db_port" "$PORT"
check_config "db_user" "$USER"
check_config "db_password" "$PASSWORD"
check_config "database" "${DB_NAME}"
check_config "db-filter" "${DB_FILTER}"
check_config "no-database-list" "${NO_DATABASE_LIST}"
check_config "without-demo" "${WITHOUT_DEMO}"
check_config "proxy-mode" "${PROXY_MODE}"
check_config "workers" "${WORKERS}"
check_config "log-level" "${LOG_LEVEL}"
check_config "limit-time-cpu" "$LIMIT_TIME_CPU"
check_config "limit-time-real" "$LIMIT_TIME_REAL"
check_config "load" "$LOAD_MODULES"
check_config "email-from" "$EMAIL_FROM"
check_config "smtp" "$SMTP_SERVER"
check_config "smtp-port" "$SMTP_PORT"
check_config "smtp-ssl" "$SMTP_SSL"
check_config "smtp-user" "$SMTP_USER"
check_config "smtp-password" "$SMTP_PASSWORD"

case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec odoo "$@"
        else
            wait-for-psql.py --db_host "${HOST}" --db_port "${PORT}" --db_user "${USER}" --db_password "${PASSWORD}" --timeout=30
            # wait-for-psql.py ${DB_ARGS[@]} --timeout=30
            exec odoo "$@" "${DB_ARGS[@]}"
        fi
        ;;
    -*)
        wait-for-psql.py --db_host "${HOST}" --db_port "${PORT}" --db_user "${USER}" --db_password "${PASSWORD}" --timeout=30
        # wait-for-psql.py ${DB_ARGS[@]} --timeout=30
        exec odoo "$@" "${DB_ARGS[@]}"
        ;;
    *)
        exec "$@"
esac

exit 1
