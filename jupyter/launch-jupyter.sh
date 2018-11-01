#!/bin/bash

export HOME_DIR=`pwd`
export DATAPROC_INIT_SRC=dataproc-initialization-actions
export DATAPROC_CLUSTER_NAME=cluster-name
export ZONE=us-central1-c
export JUPYTER_PORT=8080

if [[ ! -d "${DATAPROC_INIT_SRC}" ]]; then
  git clone https://github.com/GoogleCloudPlatform/dataproc-initialization-actions.git ${DATAPROC_INIT_SRC}
fi

#cd ${DATAPROC_INIT_SRC}/jupyter
#./launch-jupyter-interface.sh -z ${ZONE} -c ${DATAPROC_CLUSTER_NAME}
#cd ${HOME_DIR}

source "${DATAPROC_INIT_SRC}/util/utils.sh"

gcloud compute ssh cluster-name-m \
  --project=ontario-2018 \
  --zone=us-central1-c -- -D 1080 -N

"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --proxy-server="socks5://localhost:1080" \
  --user-data-dir="/tmp/cluster-name-m" http://cluster-name-m:8088