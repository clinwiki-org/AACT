#!/bin/bash

FILENAME=$1

PGHOST=$2
PGPORT=$3
PGUSER=$4
PGDATABASE=$5
# export PGPASSWORD works with -w
export PGPASSWORD=$6
TEMP_SCHEMA=$7

if [ ! $# -eq 7 ]
then
    echo "Usage: <filename> <host> <port> <user> <password> <temp_schema>"
    exit
fi

if [ ! -f "/.dockerenv" ]; then
    echo "This script should be run inside the postgres docker."
    exit
fi

# todo: -n ctgov restores everything *except* ctgov
# suggest to willy/ctd that we use something else

#echo "CREATE SCHEMA $TEMP_SCHEMA;" | psql -h $PGHOST -U $PGUSER -d $PGDATABASE -p $PGPORT -w
echo "DROP SCHEMA ctgov CASCADE; CREATE SCHEMA ctgov;" | psql -h $PGHOST -U $PGUSER -d $PGDATABASE -p $PGPORT -w
pg_restore --exit-on-error -v --no-owner --no-acl -h $PGHOST -U $PGUSER -p $PGPORT -w -d $PGDATABASE -n ctgov $FILENAME
#echo "DROP SCHEMA ctgov CASCADE;" | psql -h $PGHOST -U $PGUSER -d $PGDATABASE -p $PGPORT -w
#echo "ALTER SCHEMA $TEMP_SCHEMA RENAME TO ctgov;"| psql -h $PGHOST -U $PGUSER -d $PGDATABASE -p $PGPORT -w

