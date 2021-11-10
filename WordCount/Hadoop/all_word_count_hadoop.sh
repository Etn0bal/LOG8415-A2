#!/bin/bash

mkdir -p results

jar_file=$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar

for filename in ../../dataset/*.txt; do
    base_filename=$(basename $filename)
    hdfs dfs -rm -r output/1/$(basename $filename .txt)
    hdfs dfs -rm -r output/2/$(basename $filename .txt)
    hdfs dfs -rm -r output/3/$(basename $filename .txt)
    touch ./results/$base_filename
    { time hadoop jar $jar_file wordcount input/dataset/$base_filename output/1/$(basename $filename .txt) ; } 2>> ./results/$base_filename
    { time hadoop jar $jar_file wordcount input/dataset/$base_filename output/2/$(basename $filename .txt) ; } 2>> ./results/$base_filename
    { time hadoop jar $jar_file wordcount input/dataset/$base_filename output/3/$(basename $filename .txt) ; } 2>> ./results/$base_filename
    python ./results_parser.py ./results $base_filename
done