#!/bin/bash

export PROJECT=ontario-2018
export BUCKET=ontario-2018-dataproc
export DATAPROC_CLUSTER_NAME=mydataproc

gcloud dataproc clusters create ${DATAPROC_CLUSTER_NAME} \
    --project ${PROJECT} \
    --bucket ${BUCKET} \
    --initialization-actions \
        gs://dataproc-initialization-actions/datalab/datalab.sh