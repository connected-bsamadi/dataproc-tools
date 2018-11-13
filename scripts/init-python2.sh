#!/bin/bash

SPARK_HOME=/usr/lib/spark

# Install Python3
apt-get -y install python-dev build-essential python-pip
easy_install -U pip

# Install requirements
pip install --upgrade google-cloud==0.27.0
pip install --upgrade google-api-python-client==1.6.2
pip install --upgrade pytz==2013.7
pip install findspark
pip install jip
pip install mleap
pip install kaggle

# Install Toree
pip install  --upgrade toree

# Install Apache Toree kernel
jupyter toree install --spark_home=$SPARK_HOME