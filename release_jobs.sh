#!/usr/bin/env bash

held_job_id_list=($(squeue -hlu ${USER} |grep JobHeldUser| cut -d' ' -f 14))
for job_id in "${held_job_id_list[@]}"; do
  scontrol release $job_id
done