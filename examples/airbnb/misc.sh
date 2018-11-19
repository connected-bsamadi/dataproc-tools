
curl -XPUT -H "content-type: application/json" -d '{"path":"/models/pyspark.lr.zip"}' http://${MLEAPSERVER}:65327/model
curl -XPUT -H "content-type: application/json" -d '{"path":"/models/pyspark.logr.zip"}' http://${MLEAPSERVER}:65327/model
curl -XPUT -H "content-type: application/json" -d '{"path":"/models/airbnb.model.lr.zip"}' http://${MLEAPSERVER}:65327/model

mkdir /tmp/models
gsutil cp gs://ontario-2018-dataproc/spark-ml-models/pyspark.lr.zip /tmp/models
gsutil cp gs://ontario-2018-dataproc/spark-ml-models/pyspark.logr.zip /tmp/models
gsutil cp gs://ontario-2018-dataproc/spark-ml-models/airbnb.model.lr.zip /tmp/models

# Simple pre-configured Debian VM
# Install docker
sudo curl -sSL https://get.docker.com/ | sh

docker run -p 65327:65327 -v /tmp/models:/models combustml/mleap-serving:0.13.0-SNAPSHOT

export MLEAPSERVER=35.202.151.167
curl -XPUT -H "content-type: application/json" -d '{"path":"/models/pyspark.lr.zip"}' http://${MLEAPSERVER}:65327/model
curl -XPOST -H "accept: application/json" -H "content-type: application/json" -d @airbnb.json http://${MLEAPSERVER}:65327/transform
