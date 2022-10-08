#!/bin/bash

mkdir -p datasets
mkdir -p datasets/txt
mkdir -p datasets/csv

txt2csv='{ for (i=1; i<=123; i++) 
{ regex = " "i":1"; if($0 ~ regex) 
$(i+124)=1.0; else $(i+124)=0.0}; 
for (i=1; i<=123; i++) 
{ printf $(i+124)"|" } ; print ""}'

process_url() {
    name=$(echo $1 | cut -d "/" -f 8)
    if [[ ! -f $name ]]
    then 
        echo "$name is downloading" 
        wget --quiet $1
        echo "$name downloaded and now is reading" 
    else
        echo "$name downloaded and now is reading" 
    fi
    awk "$txt2csv" $name > ../csv/$name.csv
    echo "$name is read"
}

cd datasets/txt

set +m
for file in $(cat ../../dataset_url.txt)
do 
    process_url "$file" &
done
wait < <(jobs -p)
set -m

echo "all files downloaded"
cd ../..
