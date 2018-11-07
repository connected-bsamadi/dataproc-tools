// pyspark --jars /usr/lib/spark/jars/avro-1.7.7.jar,/usr/lib/spark/jars/spark-avro_2.11-4.0.0.jar
// Find jar files here: http://www.gtlib.gatech.edu/pub/apache/avro/avro-1.7.7/java/
:require /usr/lib/spark/jars/spark-avro_2.11-4.0.0.jar
:require /usr/lib/spark/jars/avro-1.7.7.jar
// import needed for the .avro method to be added
import com.databricks.spark.avro._
import org.apache.spark.sql.SparkSession

val spark = SparkSession.builder().master("local").getOrCreate()

// The Avro records get converted to Spark types, filtered, and
// then written back out as Avro records
val df = spark.read.avro("/datasets/twitter/twitter.avro")