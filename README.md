# dataproc-tools
Scripts for working with Google Dataproc:

- datalab: bringing up a Datalab Notebook on a Dataproc cluster
- jupyter: bringing up a Jupyter Notebook on a Dataproc cluster
- examples: example Notebooks

## Creating a Dataproc cluster
- Create a project on Google Cloud Platform
- Create a storage bucket on Google Cloud Platform
- Upload the [scripts folder](https://github.com/connected-bsamadi/dataproc-tools/tree/master/scripts) in this repository to your bucker 
- Edit the [create-cluster.sh](https://github.com/connected-bsamadi/dataproc-tools/blob/master/jupyter/create-cluster-python2.sh) script to enter your project and bucket ID's
- Run the [create-cluster.sh](https://github.com/connected-bsamadi/dataproc-tools/blob/master/jupyter/create-cluster-python2.sh) script to create a Dataproc (Spark/Hadoop) cluster

## Creating a bundle out of Spark MLlib pipelines
This [Notebook](https://github.com/connected-bsamadi/dataproc-tools/blob/master/examples/PySpark%20-%20AirBnb.ipynb) demonstrates an example of creating a Spark MLlib pipeline and saving it as a bundle. Copy the resulting bundle(s) to your storage bucket.

## Deploying a Spark MLlib pipeline into production as a REST API using MLeap
To deploy an MLeap bundle, we need to run this [Docker image](https://hub.docker.com/r/combustml/mleap-serving/tags/). In our case, since the models are stored in a Google Storage Bucket and we will use the gcloud CLI to copy the bundles to the REST API server, we will deploy a [simple pre-configured Debian VM](https://console.cloud.google.com/marketplace/partners/gcp-quickstart-vm-public). You can then connect to the instance using SSH. Then follow these steps:
- create a folder to store the bundle(s)
```
mkdir /tmp/models
```
- define the name of the bucket containing the bundle(s):
```
export BUCKET=your-bucket-name
```
- copy the bundle(s) from your bucket to the instance:
```
gsutil cp gs://$BUCKET/spark-ml-models/pyspark.lr.zip /tmp/models
```
- install Docker
```
sudo curl -sSL https://get.docker.com/ | sh
```
- run the MLeap Docker image
```
docker run -p 65327:65327 -v /tmp/models:/models combustml/mleap-serving:0.13.0-SNAPSHOT
```
