curl https://s3-us-west-2.amazonaws.com/mleap-demo/datasources/airbnb.avro -o /tmp/airbnb.avro
curl https://raw.githubusercontent.com/combust/mleap/master/examples/spark-demo.csv -o /tmp/spark-demo.csv
curl https://raw.githubusercontent.com/connected-bsamadi/dataproc-tools/blob/master/maven/target/mleap-connected_0.1-0.0.1.jar -o /usr/lib/spark/jars/mleap-connected_0.1-0.0.1.jar
curl https://search.maven.org/remotecontent?filepath=ml/combust/mleap/mleap-spark_2.11/0.12.0/mleap-spark_2.11-0.12.0.jar -o /home/datalab/mleap-spark_2.11-0.12.0.jar
curl https://drive.google.com/file/d/17P4pHHI5BApkazAe-K0b51gUXmU-zuWI/view?usp=sharing -o /home/datalab/mleap-connected_0.1-0.0.1.jar