#!/bin/bash

sudo -i

SPARK_HOME=/usr/lib/spark

# Install Toree
pip install  --upgrade toree

# Install Apache Toree kernel
jupyter toree install --spark_home=$SPARK_HOME

# Start a Jupyter Notebook Server
# jupyter notebook --port=8123 --no-browser --ip=0.0.0.0

# PYSPARK_DRIVER_PYTHON=jupyter
# PYSPARK_DRIVER_PYTHON_OPTS='notebook','--port=8123','--no-browser','--ip=0.0.0.0'

pip install findspark
pip install jip
pip install mleap