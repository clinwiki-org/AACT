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

source .env

docker run --rm -it -v .:/work -w /work postgres:$PGVERSION ./apply_snapshot_remote.sh clinical_trials.zip $PGHOST $PGPORT $PGUSER $PGDATABASE $PGPASSWORD $TEMP_SCHEMA

# execute inside docker