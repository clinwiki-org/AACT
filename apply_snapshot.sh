#!/bin/bash

AACT_ZIP=$1

WORKDIR_NAME=snapshot_temp
WORK=$(pwd)/$WORKDIR_NAME/
if [ ! -f "/.dockerenv" ]; then
    if [ ! -f "$AACT_ZIP" ]; then
        echo File '$AACT_ZIP' does not exist.
        echo Usage: ./apply_snapshot.sh [filename.zip]
        exit
    fi
    rm -rf $WORK
    mkdir -p $WORK
    unzip clinical_trials.zip -d $WORK
    echo Attempting to execute inside the running aact container...
    docker exec -w /scripts/ aact ./apply_snapshot.sh $* 2>&1 | tee log.txt
    rm -rf $WORK
    exit
fi

echo Inside docker!
cd $WORK

if [ ! -f "postgres_data.dmp" ]; then
    echo File 'postgres_data.dmp' does not exist in '$WORKDIR_NAME'
    echo Did AACT change their zipfile contents or was the zip corrupted?
    exit
fi

# Terminate any existing connections and drop the aact database
echo "select pg_terminate_backend(pid) from pg_stat_activity where datname='aact';DROP DATABASE aact; CREATE DATABASE aact;" | psql -U clinwiki

# Restore the dump, re-creating the aact database
time pg_restore -e -v -O -x -U clinwiki -w -d aact postgres_data.dmp

# Set the search_path to look in ctgov
echo "alter role clinwiki in database aact set search_path=ctgov,public;" | psql -U clinwiki
