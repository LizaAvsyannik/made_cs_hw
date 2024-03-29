#!/bin/bash
if [ $# -eq 0 ] || [ $# -gt 1 ]
then
    echo "Incorrect number of arguments"
    exit 1
else
    echo "Maximum score $1"
    for name in $(ls students)
    do  
        echo "Processing $name ..."
        hw_file="./students/$name/task1.sh"

        if [[ ! -f $hw_file ]]
        then
            echo "$name did not turn in the assignment"
        else
            ./students/$name/task1.sh > temp.txt
            unmached_lines=$(diff -w expected.txt temp.txt | grep '<\|>' | wc -l)
            if [ $unmached_lines -eq 0 ]
            then 
                echo "$name has correct output"
                echo "$name has earned a score of $1 / $1"
            else
                echo "$name has incorrect output ($unmached_lines lines do not match)"
                lost_scores=$(($1 - $unmached_lines * 5))
                lost_scores=$(( $lost_scores > 0 ? $lost_scores : 0 ))
                echo "$name has earned a score of $lost_scores / $1"
            fi
        fi
        echo ""
    done
    rm temp.txt
fi
