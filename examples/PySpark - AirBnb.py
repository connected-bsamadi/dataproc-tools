
# coding: utf-8

# # MLeap.deploy() Demo

# To set-up running Spark 2.0 (required for this demo) from a Jupyter notebook, follow these [instructions](https://github.com/combust-ml/mleap/wiki/Setting-up-a-Spark-2.0-notebook-with-MLeap-and-Toree).
# 
# This demo will show you how to:
# 1. Load the research dataset from s3
# 2. Construct a feature transformer pipeline using commonly available transformers in Spark
# 3. Deploy your model to a public model server hosted on the combust.ml cloud using .deploy()
# 
# NOTE: To run the actual deploy step you have to either:
# 1. Get a key from combust.ml - it's easy, just email us!
# 2. Fire up the combust cloud server on your local machine - also easy, send us an email and we'll send you a docker image.

# In[27]:


get_ipython().system(u'pip install --upgrade pip > /dev/null')
get_ipython().system(u'pip install jip > /dev/null')
get_ipython().system(u'pip install mleap > /dev/null')


# In[26]:


get_ipython().system(u'ls $SPARK_HOME/')


# ## Background on the Dataset

# The dataset used for the demo was pulled together from individual cities' data found [here](http://insideairbnb.com/get-the-data.html). We've also gone ahead and pulled the individual datasets and relevant features into this [research dataset](https://s3-us-west-2.amazonaws.com/mleap-demo/datasources/airbnb.avro) stored as avro.

# ### Step 0: Load libraries and data
# 

# In[2]:


from mleap import pyspark

from pyspark.ml.linalg import Vectors
from mleap.pyspark.spark_support import SimpleSparkSerializer
from pyspark.ml.feature import VectorAssembler, StandardScaler, OneHotEncoder, StringIndexer
from pyspark.ml import Pipeline, PipelineModel
from pyspark.ml.regression import LinearRegression
from pyspark.ml.classification import LogisticRegression


# In[3]:


get_ipython().system(u'curl https://s3-us-west-2.amazonaws.com/mleap-demo/datasources/airbnb.avro -o /tmp/airbnb.avro')


# In[4]:


get_ipython().system(u'hadoop fs -mkdir -p /datasets/airbnb')
get_ipython().system(u'hadoop fs -put /tmp/airbnb.avro /datasets/airbnb')
get_ipython().system(u'hadoop fs -ls /datasets/airbnb')


# In[5]:


from pyspark.sql import SparkSession
spark = SparkSession.builder.appName('abc').getOrCreate()


# In[6]:


df = spark.read.format("com.databricks.spark.avro").load("/datasets/airbnb/airbnb.avro")
df.take(1)


# In[7]:


datasetFiltered = df.filter("price >= 50 AND price <= 750 and bathrooms > 0.0")
print(df.count())
print(datasetFiltered.count())


# ### Step 1: Standardize the data for our demo 

# In[8]:


datasetFiltered.registerTempTable("df")

datasetImputed = spark.sql("""
    select
        id,
        city,
        case when state in('NY', 'CA', 'London', 'Berlin', 'TX' ,'IL', 'OR', 'DC', 'WA')
            then state
            else 'Other'
        end as state,
        space,
        price,
        bathrooms,
        bedrooms,
        room_type,
        host_is_superhost,
        cancellation_policy,
        case when security_deposit is null
            then 0.0
            else security_deposit
        end as security_deposit,
        price_per_bedroom,
        case when number_of_reviews is null
            then 0.0
            else number_of_reviews
        end as number_of_reviews,
        case when extra_people is null
            then 0.0
            else extra_people
        end as extra_people,
        instant_bookable,
        case when cleaning_fee is null
            then 0.0
            else cleaning_fee
        end as cleaning_fee,
        case when review_scores_rating is null
            then 80.0
            else review_scores_rating
        end as review_scores_rating,
        case when square_feet is not null and square_feet > 100
            then square_feet
            when (square_feet is null or square_feet <=100) and (bedrooms is null or bedrooms = 0)
            then 350.0
            else 380 * bedrooms
        end as square_feet,
        case when bathrooms >= 2
            then 1.0
            else 0.0
        end as n_bathrooms_more_than_two
    from df
    where bedrooms is not null
""")


datasetImputed.select("square_feet", "price", "bedrooms", "bathrooms", "cleaning_fee").describe().show()


# ### Step 1.1: Take a look at some summary statistics of the data
# 

# In[9]:


# Most popular cities (original dataset)

spark.sql("""
    select 
        state,
        count(*) as n,
        cast(avg(price) as decimal(12,2)) as avg_price,
        max(price) as max_price
    from df
    group by state
    order by count(*) desc
""").show()


# In[10]:


# Most expensive popular cities (original dataset)

spark.sql("""
    select 
        city,
        count(*) as n,
        cast(avg(price) as decimal(12,2)) as avg_price,
        max(price) as max_price
    from df
    group by city
    order by avg(price) desc
""").filter("n>25").show()


# ### Step 2: Define continous and categorical features
# 

# In[11]:


# Step 2. Create our feature pipeline and train it on the entire dataset
continuous_features = ["bathrooms", "bedrooms", "security_deposit", "cleaning_fee", "extra_people", "number_of_reviews", "square_feet", "review_scores_rating"]

categorical_features = ["room_type", "host_is_superhost", "cancellation_policy", "instant_bookable", "state"]

all_features = continuous_features + categorical_features


# In[12]:


dataset_imputed = datasetImputed.persist()


# ### Step 3: Split data into training and validation 

# In[13]:


[training_dataset, validation_dataset] = dataset_imputed.randomSplit([0.7, 0.3])


# ### Step 4: Continous Feature Pipeline

# In[14]:


continuous_feature_assembler= VectorAssembler(inputCols=continuous_features, outputCol="unscaled_continuous_features")

continuous_feature_scaler = StandardScaler(inputCol="unscaled_continuous_features", outputCol="scaled_continuous_features",                                           withStd=True, withMean=False)


# ### Step 5: Categorical Feature Pipeline

# In[15]:


categorical_feature_indexers = [StringIndexer(inputCol=x, outputCol="{}_index".format(x)) for x in categorical_features]

categorical_feature_one_hot_encoders = [OneHotEncoder(inputCol=x.getOutputCol(), outputCol="oh_encoder_{}".format(x.getOutputCol() )) for x in categorical_feature_indexers]


# ### Step 6: Assemble our features and feature pipeline
# 

# In[16]:


estimatorsLr = [continuous_feature_assembler, continuous_feature_scaler] + categorical_feature_indexers+ categorical_feature_one_hot_encoders

featurePipeline = Pipeline(stages=estimatorsLr)

sparkFeaturePipelineModel = featurePipeline.fit(dataset_imputed)

print("Finished constructing the pipeline")


# ### Step 7: Train a Linear Regression Model

# In[17]:


# Create our linear regression model

linearRegression = LinearRegression(featuresCol="scaled_continuous_features", labelCol="price", predictionCol="price_prediction", maxIter=10, regParam=0.3, elasticNetParam=0.8)

pipeline_lr = [sparkFeaturePipelineModel] + [linearRegression]

sparkPipelineEstimatorLr = Pipeline(stages = pipeline_lr)

sparkPipelineLr = sparkPipelineEstimatorLr.fit(dataset_imputed)

print("Complete: Training Linear Regression")


# ### Step 7.1: Train a Logistic Regression Model

# In[18]:


# Create our logistic regression model

logisticRegression = LogisticRegression(featuresCol="scaled_continuous_features", labelCol="n_bathrooms_more_than_two", predictionCol="n_bathrooms_more_than_two_prediction", maxIter=10)

pipeline_log_r = [sparkFeaturePipelineModel] + [logisticRegression]

sparkPipelineEstimatorLogr = Pipeline(stages = pipeline_log_r)

sparkPipelineLogr = sparkPipelineEstimatorLogr.fit(dataset_imputed)

print("Complete: Training Logistic Regression")


# ### Step 8: Serialize the model to Bundle.ML

# In[19]:


sparkPipelineLr.serializeToBundle("jar:file:/tmp/pyspark.lr.zip", sparkPipelineLr.transform(dataset_imputed))
sparkPipelineLogr.serializeToBundle("jar:file:/tmp/pyspark.logr.zip", dataset=sparkPipelineLogr.transform(dataset_imputed))


# ### Step 9 (Optional): Deserialize from Bundle.ML

# In[ ]:


sparkPipelineLr = PipelineModel.deserializeFromBundle("jar:file:/tmp/pyspark.lr.zip")


# ### Step 10 (Optional): Deploy to ModelServer

# Python bindings for .deploy() are coming soon. For now, you may have to write a few lines of scala - demo for that can be found [here](https://github.com/combust-ml/mleap-demo/blob/master/lending-club/notebooks/airbnb-price-regression.ipynb).
