# AACT Mirror

## To start the database server run `docker-compose up -d`  This starts the postgresql server on port 5432.  The username and password are in the file.

There are 3 scripts that are used to create and update the aact database.

### download_aact_snapshot.sh
Attempts to download the latest AACT snapshot zip file from https://aact.ctti-clinicaltrials.org/.  Saves it as clinicial_trials.zip in the current directory.

### apply_snapshot.sh <filename>
Unzips the provided AACT zip file and executes a pg_restore inside the _running_ `aact` container.  If the database is not running this won't work.

### update_aact.sh
1. Downloads the snapshot using download_aact_snapshot.sh
2. Does a sanity check on the zip file and if it's good...
3. Runs apply_snapshot



