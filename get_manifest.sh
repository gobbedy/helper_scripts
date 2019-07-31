#!/bin/bash

all_jobs=''
while [[ "$1" == -* ]]; do
  case "$1" in
    --all_jobs)
      all_jobs=1
      shift 1
    ;;
  esac
done

regress_dir=${SLURM_SIMULATION_TOOLKIT_REGRESS_DIR}
if [[ -z ${all_jobs} ]]; then
  grep -l $(basename $(dirname $(scontrol show jobid=$1 | grep StdOut | grep -oP '[^=]+$'))) $PWD/regressions/*
else
  all_job_id_list=($(squeue -hlu kongfs |grep RUNNING| cut -d' ' -f 14))
  for job_id in "${all_job_id_list[@]}"; do
      grep -l $(basename $(dirname $(scontrol show jobid=$job_id | grep StdOut | grep -oP '[^=]+$'))) ${regress_dir}/*/*/batch_summary/log_manifest.txt
  done
fi
