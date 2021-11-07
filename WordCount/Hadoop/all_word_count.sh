#!/bin/bash
for filename in ../../dataset/*.txt; do 
    touch $(basename $filename);
    { time hadoop jar /home/azureuser/hadoop-3.3.1/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar wordcount input/dataset/$(basename $filename) output/1/$(basename $filename .txt) ; } 2>> $(basename $filename)
    { time hadoop jar /home/azureuser/hadoop-3.3.1/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar wordcount input/dataset/$(basename $filename) output/2/$(basename $filename .txt) ; } 2>> $(basename $filename)
    { time hadoop jar /home/azureuser/hadoop-3.3.1/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar wordcount input/dataset/$(basename $filename) output/3/$(basename $filename .txt) ; } 2>> $(basename $filename)
done