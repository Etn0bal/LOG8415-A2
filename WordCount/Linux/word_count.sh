cat ./dataset/$1 | tr " " "
" | sort | uniq -c 

