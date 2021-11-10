cd WordCount
cd Hadoop
echo "Running Hadoop experiments"
./all_word_count_hadoop.sh
cd ..
echo "Running Spark experiments"
cd Spark
./all_word_count_spark.sh
echo "Done"
cd ../..