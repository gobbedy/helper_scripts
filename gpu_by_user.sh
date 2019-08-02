#!/bin/bash
source ${SLURM_SIMULATION_TOOLKIT_HOME}/config/simulation_toolkit.rc

function showHelp {

echo "NAME
  $me -
     1) Print regression results, for individual simulations and/or for entire regression
           a) Optionally print average test error over last 10 epochs for each simulation
           b) Print mean of average test error over all simulations
           c) Print standard deviation of average test errors.
     2) Optionally plots training loss and test error curves for each simulations
           a) Generates latex using templating
           b) Converts latex to PDF: plots are optionally all in one pdf or one PDF per simulation
           c) Optionally attaches PDF(s) to summary e-mail
     3) Optionally plots a histogram of the average test errors with Gaussian curve overlay.
            --TODO: clean up support of different overlay curves for different datasets/models.
           a) Generates latex histogram with Gaussian overlay. Overlay is a golden reference provided by user.
           b) Converts latex to PDF
           c) Optionally attaches PDF to summary e-mail
     4) E-mails results to user

SYNOPSIS
  $me [-l LOGFILE | -f MANIFEST] [OPTIONS]

OPTIONS
  -h, --help
                          Show this description

  -p PARTITION
                          PARTITION is the name of the cluster partition to check. Default is dell partition provided
                          (aka beihang system's default partition).
"
}

partition='dell'
while [[ "$1" == -* ]]; do
  case "$1" in
    -h|--help)
      showHelp
      exit 0
    ;;
    -p)
      partition=$2
      shift 2
    ;;
    -*)
      echo "Invalid option $1"
      exit 1
    ;;
  esac
done

if [[ ${partition} == "dell" ]]; then
    total_gpus=112
elif [[ ${partition} == "sugon" ]]; then
    total_gpus=34
else
    die "unsupported partition (${partition})"
fi

# This script is designed to work on Beihang; would need some fiddling to work on a different cluster
job_id_list=(`squeue -lha | grep -w ${partition} | grep RUNNING | grep -oP '^\s+\K\d+'`)
declare -A usage_list
for job_id in "${job_id_list[@]}"
do
    user=$(scontrol show jobid=${job_id} | grep -oP 'UserId[^ ]+' | grep -oP '[^=]+$' | grep -oP '^[^(]+')
    num_gpus=$(scontrol show jobid=${job_id} | grep -oP 'gres/gpu.*' | grep -oP '\d+$')
    if [[ -z ${num_gpus} ]]; then
      echo "***WARNING: $user is running job ${job_id} with no GPUs. See below. ***"
      squeue -lha | grep -w ${job_id}
      echo ""
    fi
    prior_num_gpus="${usage_list[$user]}"
#echo $prior_num_gpus
    num_gpus=$((prior_num_gpus + num_gpus))
    usage_list[$user]=$num_gpus
done

total_gpu_in_use=0
for user in "${!usage_list[@]}"; do
    num_gpus=${usage_list[$user]}
    total_gpu_in_use=$((total_gpu_in_use+num_gpus))
    printf "User %s is using %s GPUs.\n" "$user" "$num_gpus"
done

echo ""
printf "Total number of GPUs in use: %s\n" "$total_gpu_in_use"

unused_gpus=$((${total_gpus}-total_gpu_in_use))
printf "Number of unused GPUs: %s\n" "$unused_gpus"