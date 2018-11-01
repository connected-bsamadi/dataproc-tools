#!/bin/bash

export PROJECT=ontario-2018
export DATAPROC_CLUSTER_NAME=mydataproc
export ZONE=us-central1-c
export DATALAB_PORT=8888

gcloud compute ssh ${DATAPROC_CLUSTER_NAME}-m \
    --project=${PROJECT} --zone=${ZONE}  -- \
    -D ${PORT} -N