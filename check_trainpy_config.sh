#!/usr/bin/env bash

manifest=$1

log1=$(head -n1 $manifest)
grep -v seed  $log1 | grep -v name | grep -v one_lambda | grep -v normalize > log1
first_line_number_of_config=$(grep -n 'lr ' log1| cut -f1 -d:)
last_line_number_of_config=$((first_line_number_of_config+19))
sed_quit_line_number=$((first_line_number_of_config+20))

sed -n "$first_line_number_of_config,${last_line_number_of_config}p;${sed_quit_line_number}q" log1 > config1
sed -i -e 's/\[/\(/g' config1
sed -i -e 's/\]/\)/g' config1

idx=0
for log in $(cat $manifest)
do
    echo $idx
    #echo $log
    grep -v seed  $log | grep -v name | grep -v one_lambda |grep -v normalize > log
    first_line_number_of_config=$(grep -n 'lr ' log| cut -f1 -d:)
    last_line_number_of_config=$((first_line_number_of_config+19))
    sed_quit_line_number=$((first_line_number_of_config+20))
    one_lambda=$(grep 'one_lambda_per_batch True' $log)
    if [[ -n $one_lambda ]]; then
      echo "one lambda"
    fi
    sed -n "$first_line_number_of_config,${last_line_number_of_config}p;${sed_quit_line_number}q" log > config
    sed -i -e 's/\[/\(/g' config
    sed -i -e 's/\]/\)/g' config
    cmp config config1
    if [[ $? -ne 0 ]]; then
        echo $log
        exit 1
    fi
    idx=$((idx+1))
done