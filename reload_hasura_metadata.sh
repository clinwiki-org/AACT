#!/bin/bash

HASURA_SECRET=$1
HASURA_HOST=$2

curl -H 'X-Hasura-Admin-Secret: $HASURA_SECRET' -d'{"type":
"reload_metadata", "args": {}}' https://$HASURA_HOST/v1/metadata

