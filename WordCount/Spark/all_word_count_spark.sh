#!/bin/bash

mkdir -p results

py_file=./word_count.py

for filename in ../../dataset/*.txt; do
    base_filename=$(basename $filename)
    rm ./results/$base_filename
    touch ./results/$base_filename
    { time spark-submit $py_file $filename ; } 2>> ./results/$base_filename
    { time spark-submit $py_file $filename ; } 2>> ./results/$base_filename
    { time spark-submit $py_file $filename ; } 2>> ./results/$base_filename
    python3 ../../utils/results_parser.py ./results $base_filename
done