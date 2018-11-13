#!/bin/bash

SPARK_HOME=/usr/lib/spark
readonly ROLE="$(/usr/share/google/get_metadata_value attributes/dataproc-role)"

# Install Python3
apt-get -y install python3 python-dev build-essential python3-pip
easy_install3 -U pip

# Install requirements
pip3 install --upgrade google-cloud==0.27.0
pip3 install --upgrade google-api-python-client==1.6.2
pip3 install --upgrade pytz==2013.7
pip3 install findspark
pip3 install jip
pip3 install mleap
pip3 install kaggle


# Setup python3 for Dataproc
echo "export PYSPARK_PYTHON=python3" | tee -a  /etc/profile.d/spark_config.sh  /etc/*bashrc /usr/lib/spark/conf/spark-env.sh
echo "export PYTHONHASHSEED=0" | tee -a /etc/profile.d/spark_config.sh /etc/*bashrc /usr/lib/spark/conf/spark-env.sh
echo "spark.executorEnv.PYTHONHASHSEED=0" >> /etc/spark/conf/spark-defaults.conf

if [[ "${ROLE}" == 'Master' ]]; then
   # Install Jupyter
   pip3 install jupyter

   # Install Toree
   pip3 install  --upgrade toree
   
   # Install Apache Toree kernel
   jupyter toree install --spark_home=$SPARK_HOME
   
   jupyter notebook --ip 0.0.0.0 --port 8123 --no-browser
fi