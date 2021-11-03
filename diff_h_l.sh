for l in $(ls ./dataset)
do
    time hadoop jar ~/hadoop-3.3.1/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar wordcount input/wordcount/dataset/$l output/$l
done
