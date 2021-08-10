# AACT Mirror

Mirror aact to the specified remote postgresql instance.

To run create the enviroment file and run update_aact_remote.sh.  (This will call download_aact_snapshot, apply_snapshot_remote and reload_hasura_metadata)


# Environment Variables (with defaults)

PGUSER
PGPASS
PGHOST
PGPORT
PGDATABASE
PGVERSION=13
FINAL_SCHEMA=ctgov_prod
HASURA_HOST
HASURA_SECRET

