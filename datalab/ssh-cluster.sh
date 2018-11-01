#!/bin/bash

export PROJECT=ontario-2018
export ZONE=us-central1-c
export DATAPROC_CLUSTER_NAME=mydataproc

gcloud compute --project ${PROJECT} ssh --zone ${ZONE} "${DATAPROC_CLUSTER_NAME}-m"
