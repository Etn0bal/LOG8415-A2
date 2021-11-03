for l in $(ls ./dataset)
do
    mytime="$(hadoop jar ~/hadoop-3.3.1/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar wordcount input/wordcount/dataset/$l output/$l  ) 2>&1 1>/dev/null )"
    echo $l $mytime
done
