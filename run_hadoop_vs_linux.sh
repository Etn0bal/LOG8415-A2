cd WordCount
cd Hadoop
echo "Running Hadoop experiments"
./all_word_count_hadoop.sh
cd ..
echo "Running Linux experiments"
cd Linux
./all_word_count_linux.sh
echo "Done"
cd ../..