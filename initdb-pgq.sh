#!/bin/bash

set -ex

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create the 'template_pgq' template db
cat | psql <<-'EOSQL'
CREATE DATABASE template_pgq IS_TEMPLATE true;
EOSQL

# Load PgQ into both template_database and $POSTGRES_DB
for DB in template_pgq "$POSTGRES_DB"; do
	echo "Loading PgQ extensions into $DB"
	cat | psql --dbname="$DB" <<-'EOSQL'
		CREATE EXTENSION IF NOT EXISTS pgq;
		CREATE EXTENSION IF NOT EXISTS pgq_coop;
EOSQL
done
