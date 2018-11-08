#!/bin/bash

export PROJECT=ontario-2018
export BUCKET=ontario-2018-dataproc
export DATAPROC_CLUSTER_NAME=mydataproc

gcloud dataproc clusters create ${DATAPROC_CLUSTER_NAME} \
  --project ${PROJECT} \
  --bucket ${BUCKET} \
  --metadata "JUPYTER_PORT=8123,JUPYTER_CONDA_PACKAGES=numpy:pandas:scikit-learn" \
  --initialization-actions \
      gs://dataproc-initialization-actions/jupyter/jupyter.sh \
  --properties spark.jars.packages='ml.combust.mleap:mleap-base_2.11:0.10.0,ml.combust.mleap:mleap-core_2.11:0.10.0'