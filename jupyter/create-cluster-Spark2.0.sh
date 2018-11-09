#!/bin/bash

export PROJECT=ontario-2018
export BUCKET=ontario-2018-dataproc
export DATAPROC_CLUSTER_NAME=mydataproc

gcloud dataproc clusters create ${DATAPROC_CLUSTER_NAME} \
  --project ${PROJECT} \
  --bucket ${BUCKET} \
  --image-version=1.1 \
  --metadata "JUPYTER_PORT=8123,JUPYTER_CONDA_PACKAGES=numpy:pandas:scikit-learn" \
  --initialization-actions \
      gs://dataproc-initialization-actions/jupyter2/jupyter2.sh \
  --properties spark:spark.jars.packages='ml.combust.mleap:mleap-base_2.11:0.12.0' \
  --properties spark:spark.jars.packages='ml.combust.mleap:mleap-core_2.11:0.12.0' \
  --properties spark:spark.jars.packages='ml.combust.mleap:mleap-runtime_2.11:0.12.0' \
  --properties spark:spark.jars.packages='ml.combust.mleap:mleap-spark_2.11:0.12.0' \
  --properties spark:spark.jars.packages='ml.combust.mleap:mleap-spark-base_2.11:0.12.0' \
  --properties spark:spark.jars.packages='ml.combust.mleap:mleap-tensor_2.11:0.12.0' \
  --properties spark:spark.jars.packages='com.databricks:spark-avro_2.11:4.0.0' 