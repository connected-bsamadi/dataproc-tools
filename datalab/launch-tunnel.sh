#!/bin/bash

export PROJECT=ontario-2018
export DATAPROC_CLUSTER_NAME=mydataproc
export ZONE=us-central1-c
export DATALAB_PORT=8080

gcloud compute ssh ${DATAPROC_CLUSTER_NAME}-m \
    --project=${PROJECT} --zone=${ZONE}  -- \
    -D ${PORT} -N

"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --proxy-server="socks5://localhost:${PORT}" \
  --user-data-dir=/tmp/${DATAPROC_CLUSTER_NAME}