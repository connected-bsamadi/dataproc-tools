#!/bin/bash

# Install MLeap: 
spark-shell --packages ml.combust.mleap:mleap-spark_2.11:0.10.0

# Install Avro Data Source for Apache Spark: 
spark-shell --packages com.databricks:spark-avro_2.11:4.0.0