#!/bin/bash

export DATAPROC_CLUSTER_NAME=mydataproc

gcloud dataproc clusters delete ${DATAPROC_CLUSTER_NAME}