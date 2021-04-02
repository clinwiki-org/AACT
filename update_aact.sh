#!/bin/bash

# Download the latest snapshot
./download_aact_snapshot.sh

# Check if the snapshot downloaded successfully
if zipinfo clinical_trials.zip > /dev/null; then
   echo Valid zip file
else
   echo Invalid zip. Abort. | tee log.txt
   exit
fi

# If it did apply the snapshot
./apply_snapshot.sh clinical_trials.zip