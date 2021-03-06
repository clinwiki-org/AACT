#!/bin/bash

cd "$(dirname "$0")"
source log.sh

# Download the latest snapshot
log info Downloading AACT snapshot
./download_aact_snapshot.sh

log info Download complete. Validating...
# Check if the snapshot downloaded successfully
if zipinfo clinical_trials.zip > /dev/null; then
   log info Valid zip file
else
   log error Invalid zip. Abort.
   exit
fi

# unzip into temp
log info Decompressing...
WORK=snapshot_temp
rm -rf $WORK
mkdir -p $WORK
unzip clinical_trials.zip -d $WORK

source .env

log info Applying snapshot...
docker run --rm -v $PWD:/work -w /work postgres:$PGVERSION ./apply_snapshot.sh $WORK/postgres_data.dmp $PGHOST $PGPORT $PGUSER $PGDATABASE $PGPASS $FINAL_SCHEMA
log info Done applying snapshot.

rm -rf $WORK
if [[ ! -z "$HASURA_USER" ]]; then
	log info Loading metadata...
	log info $(./reload_hasura_metadata.sh)
fi

