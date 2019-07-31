#!/usr/bin/env bash

manifest=$1
logfiles=($(cat $manifest))
for (( idx=0; idx<${#logfiles[@]}; idx++ ));
do
{
    logfile=${logfiles[${idx}]}
    echo "Processing $logfile"
    parent_dir=$(dirname ${logfile})
    slurm_logfile=$(ls ${parent_dir}/*.slurm)
    job_id=$(grep -oP 'Submitted batch job \K.+' ${slurm_logfile})
    node=$(sacct -j $job_id -p -o NodeList | grep -vm 1 NodeList | grep -oP '^[^|]+')
    echo $node
}
done