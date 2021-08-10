#!/bin/bash

cd "$(dirname "$0")"

# Download the latest snapshot
./download_aact_snapshot.sh

# Check if the snapshot downloaded successfully
if zipinfo clinical_trials.zip > /dev/null; then
   echo Valid zip file
else
   echo Invalid zip. Abort. | tee log.txt
   exit
fi

# unzip into temp
WORK=snapshot_temp
rm -rf $WORK
mkdir -p $WORK
unzip clinical_trials.zip -d $WORK

source .env

docker run --rm -it -v $PWD:/work -w /work postgres:$PGVERSION ./apply_snapshot_remote.sh $WORK/postgres_data.dmp $PGHOST $PGPORT $PGUSER $PGDATABASE $PGPASSWORD $FINAL_SCHEMA

rm -rf $WORK
./reload_hasura_metadata.sh $HASURA_SECRET $HASURA_HOST

