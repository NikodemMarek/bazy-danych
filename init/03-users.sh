#!/bin/bash
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"\
 -v admin_pass="$ADMIN_DB_PASS" -v application_pass="$APP_DB_PASS" -v analyst_pass="$ANALYST_DB_PASS"\
 -f /docker-entrypoint-initdb.d/templates/user-accounts.sql