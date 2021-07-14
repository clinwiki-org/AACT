#!/bin/bash

HASURA_SECRET=$1
HASURA_HOST=$2

# This is the command to remotely reload the schema. Replace *** with the admin secret
curl -H 'X-Hasura-Admin-Secret: $HASURA_SECRET' -d'{"type":
"reload_metadata", "args": {}}' https://$HASURA_HOST/v1/metadata

