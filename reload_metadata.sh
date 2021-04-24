#!/bin/bash

# This is the command to remotely reload the schema. Replace *** with the admin secret
curl -H 'X-Hasura-Admin-Secret: ***' -d'{"type":
"reload_metadata", "args": {}}' https://clinwiki-crowd-exp.hasura.app/v1/metadata

