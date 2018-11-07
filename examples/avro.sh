#!/bin/bash
export PYSPARK_SUBMIT_ARGS='/usr/lib/spark/jars/avro-1.7.7.jar,/usr/lib/spark/jars/spark-avro_2.11-4.0.0.jar'
pyspark --jars /usr/lib/spark/jars/avro-1.7.7.jar,/usr/lib/spark/jars/spark-avro_2.11-4.0.0.jar