hdfs dfs -copyFromLocal ./dataset/soc-LiveJournal1Adj.txt input/dataset/soc-LiveJournal1Adj.txt
hadoop jar ./MapReduce/compiled/MapReduce-1.0-SNAPSHOT-jar-with-dependencies.jar input/dataset/soc-LiveJournal1Adj.txt output/social
touch social_result.txt
hdfs dfs -cat output/social/part-r-00000 >> social_result.txt