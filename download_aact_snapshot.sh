#!/bin/bash

# Download the latest AACT database snapshot from ctti-clinicaltrials.org
# Only uses the daily snapshots

if [ -z "$BASE_URL" ]; then
    BASE_URL=https://aact.ctti-clinicaltrials.org/static/static_db_copies/daily
fi

# Start with today and go back up to 4 days to find a valid zip file
DATES=(
    $(date -d "today" +"%Y%m%d")
    $(date -d "1 days ago" +"%Y%m%d")
    $(date -d "2 days ago" +"%Y%m%d")
    $(date -d "3 days ago" +"%Y%m%d")
    $(date -d "4 days ago" +"%Y%m%d")
)
for x in ${DATES[@]}; do
URL=$BASE_URL/${x}_clinical_trials.zip
echo $URL
RES=$(curl -k -w "%{http_code}" -o clinical_trials.zip $URL)
if [ $RES == "200" ]
then 
echo SUCCESS
break;
fi
done