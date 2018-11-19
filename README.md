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
- Make sure you have access to these ports on the master node of the cluster: 8088,9780,8080,8123,4042,65327

## Creating a bundle out of Spark MLlib pipelines
This [Notebook](https://github.com/connected-bsamadi/dataproc-tools/blob/master/examples/PySpark%20-%20AirBnb.ipynb) demonstrates an example of creating a Spark MLlib pipeline and saving it as a bundle. A Jupyter Notebook server is available on port 8123 of the master node of the Dataproc cluster. You can upload and run the [Airbnb Notebook](https://github.com/connected-bsamadi/dataproc-tools/blob/master/examples/PySpark%20-%20AirBnb.ipynb) to get a bundle as `pyspark.lr.zip`. Then, copy the resulting bundle (zip file) to your storage bucket using the gcloud CLI.

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

Now, you can use another machine to communicate with the MLeap server. Before sending commands to the server make sure that you have defined the right [firewall rules](https://console.cloud.google.com/networking/firewalls/list) so that you have the permissions required for communicating with the port 65327 on the MLeap server. Now, you can follow these steps:

- define the IP address of the MLeap server
```
export MLEAPSERVER=35.202.151.167
```
- tell the MLeap server which model you want to use:
```
curl -XPUT -H "content-type: application/json" -d '{"path":"/models/pyspark.lr.zip"}' http://${MLEAPSERVER}:65327/model
```
- create a JSON file that includes the input data you want to send to the MLeap server. There is an example for such [JSON input file](https://github.com/connected-bsamadi/dataproc-tools/blob/master/examples/airbnb/airbnb.json) in this repository.
- send the JSON input data to the MLeap server:
```
curl -XPOST -H "accept: application/json" -H "content-type: application/json" -d @airbnb.json http://${MLEAPSERVER}:65327/transform
```