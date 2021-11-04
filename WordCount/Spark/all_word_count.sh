#!/bin/bash
for filename in ../../dataset/*.txt; do 
    time spark-submit ./word_count.py ../dataset/$filename ./${filename%.txt}/
done