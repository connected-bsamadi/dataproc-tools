#!/bin/bash

export PROJECT=ontario-2018
export BUCKET=ontario-2018-dataproc
export DATAPROC_CLUSTER_NAME=mydataproc
export JUPYTER_PORT=8080

gcloud beta dataproc clusters create ${DATAPROC_CLUSTER_NAME} \
  --project ${PROJECT} \
  --bucket ${BUCKET} \
  --optional-components=ANACONDA,JUPYTER \
  --image-version=1.3-deb9