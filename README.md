docker run -it --hostname namenode -p 50070:50070 saxcorp/hadoop_2.7.3_namenode


##Cleaning docker context : 
docker stop $(docker ps -a -q) 
docker rm $(docker ps -a -q)
docker image prune -f
docker volume prune 

##Load configure docker client with specific docker node : 
eval $("docker-machine.exe" env --shell bash node-1)


spark-submit --class org.apache.spark.examples.SparkPi \
    --master spark://spark-master:6066  \
    --deploy-mode cluster \
    --num-executors 1 \
    --driver-memory 512m \
    --executor-memory 512m \
    --executor-cores 1 \
    spark-examples*.jar 10
	
spark-submit --class org.apache.spark.examples.SparkPi \
    --master yarn  \
    --deploy-mode cluster \
    --num-executors 1 \
    --driver-memory 512m \
    --executor-memory 512m \
    --executor-cores 1 \
    spark-examples*.jar 10
	
spark-submit --deploy-mode client \
--class org.apache.spark.examples.SparkPi \
$SPARK_HOME/examples/jars/spark-examples*.jar 10# docker-hadoop-eco-sys
