#!/bin/bash

FILENAME=$1
PGHOST=$2
PGPORT=$3
PGUSER=$4
PGDATABASE=$5

# export PGPASSWORD works with -w
export PGPASSWORD=$6
FINAL_SCHEMA=$7

if [ ! $# -eq 7 ]
then
    echo "Usage: <filename> <host> <port> <user> <database> <password> <final_schema>"
    exit
fi

if [ ! -f "/.dockerenv" ]; then
    echo "This script should be run inside the postgres docker."
    exit
fi

run_sql() {
    echo $1 | psql -h $PGHOST -U $PGUSER -d $PGDATABASE -p $PGPORT -w
}

run_sql "DROP SCHEMA IF EXISTS ctgov_old CASCADE; ALTER SCHEMA $FINAL_SCHEMA RENAME TO ctgov_old;"
run_sql "DROP SCHEMA IF EXISTS $FINAL_SCHEMA CASCADE; ALTER SCHEMA ctgov RENAME TO $FINAL_SCHEMA;"
run_sql "DROP SCHEMA IF EXISTS ctgov CASCADE; CREATE SCHEMA ctgov;"
pg_restore --exit-on-error -v --no-owner --no-acl -h $PGHOST -U $PGUSER -p $PGPORT -w -d $PGDATABASE -n ctgov $FILENAME

