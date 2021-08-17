#!/bin/bash

cd "$(dirname "$0")"
source log.sh
source .env


if [ ! -f "/.dockerenv" ]; then
  log what "Re-runnng inside docker"
  docker run --rm -v $PWD:/work -w /work postgres:$PGVERSION ./whatchanged.sh
  exit
fi

export PGPASSWORD=$PGPASS
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -p $PGPORT -w -c 'copy (select * from ctgov_prod.studies where nct_id in (select prod.nct_id from ctgov_prod.studies prod join ctgov_prev.studies prev on prod.nct_id = prev.nct_id where prod.updated_at > prev.updated_at)) to stdout with csv header' > new.csv
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -p $PGPORT -w -c 'copy (select * from ctgov_prev.studies where nct_id in (select prod.nct_id from ctgov_prod.studies prod join ctgov_prev.studies prev on prod.nct_id = prev.nct_id where prod.updated_at > prev.updated_at)) to stdout with csv header' > old.csv

