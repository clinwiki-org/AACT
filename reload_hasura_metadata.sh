#!/bin/bash

source .env

curl -H "X-Hasura-Admin-Secret: $HASURA_SECRET" -d'{"type":
"reload_metadata", "args": {}}' https://$HASURA_HOST/v1/metadata

