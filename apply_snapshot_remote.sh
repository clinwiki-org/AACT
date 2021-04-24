#!/bin/bash

FILENAME=$1

PGHOST=$2
PGPORT=$3
PGUSER=$4
# export PGPASSWORD works with -w
export PGPASSWORD=$5

if [ ! $# -eq 5 ]
then
	echo "Usage: <filename> <host> <port> <user> <password>"
	exit
fi


if [ ! -f "/.dockerenv" ]; then
	echo "This script should be run inside the postgres docker."
	exit
fi

echo "drop schema ctgov cascade; create schema ctgov" | psql -h $PGHOST -U $PGUSER -d clinwiki -p $PGPORT -w
pg_restore --exit-on-error -v --no-owner --no-acl -h $PGHOST -U $PGUSER -p $PGPORT -w -d clinwiki -n ctgov $FILENAME

