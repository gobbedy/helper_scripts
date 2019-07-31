#!/usr/bin/env bash
source ${SLURM_SIMULATION_TOOLKIT_HOME}/config/simulation_toolkit.rc

manifest=$1
max_jobs_in_parallel=$2
preserve_order=''

regression_summary_dir=$(dirname ${manifest})
batch_outputs_logfile=${regression_summary_dir}/batch_outputs.log

unset pid_list
declare -A pid_list

pending_job_id_list=($(squeue -hlu ${USER} |grep PENDING| cut -d' ' -f 14))
job_id_list=($(cat $(grep "JOB IDs FILE IN:" ${batch_outputs_logfile} | grep -oP "\S+$")))
# note: there can be fewer than max jobs if some jobs finish early. then some jobs may still be waiting for a job
# to start; eg if max is 8, then jobs 1-8 start right away; say that job 2 fails early; job 9 is waiting for job 1
# to finish, so won't start right away; job 10 is waiting for job 9 to start, so also won't start right away;
# so until job 1 finishes, no new jobs will be run

cat $(grep "JOB IDs FILE IN:" ${batch_outputs_logfile} | grep -oP "\S+$") > all_jobs.txt
for (( idx=0; idx<${#job_id_list[@]}; idx++ ));
do
{
    job_id=${job_id_list[${idx}]}

    # if not pending, skip the update (since job is running or has finished already)
    if [[ ! ${pending_job_id_list[@]} =~ " ${job_id} " ]]; then
        continue
    fi

    dependency=""
    if [[ -n ${max_jobs_in_parallel} ]]; then

        # an easy way to implement max number of jobs would be to use singleton
        # however if want max number of jobs WITH preserving order, CANNOT use singleton because
        # singleton does not work in combination with other dependencies (slurm bug?)
        # instead, impose max number of jobs in parallel by waiting for prior jobs to finish
        if [[ ${idx} -ge ${max_jobs_in_parallel} ]]; then
            depend_idx=$((idx-max_jobs_in_parallel))
            depend_job_id=${job_id_list[${depend_idx}]}
            dependency+="afterany:${depend_job_id}"

            #echo "${job_id} depends on ${depend_job_id} finishing."
        fi

    fi
    if [[ -n ${preserve_order} ]]; then
        if [[ ${idx} -ne 0 ]]; then
            if [[ -n ${dependency} ]]; then
                dependency+=","
            fi
            prev_idx=$((idx-1))
            prev_job_id=${job_id_list[${prev_idx}]}
            dependency+="after:${prev_job_id}"

            #echo "${job_id} depends on ${prev_job_id} starting."
        fi
    fi


    dependency_option=''
    if [[ -n ${dependency} ]]; then
        dependency_option="Dependency=${dependency}"
    fi

    scontrol update jobid=${job_id} ${dependency_option}
    :
}&
pid=$!
pid_list[$pid]=1
done

process_error=0
for pid in "${!pid_list[@]}"
do
{
    wait $pid
    if [[ $? -ne 0 ]]; then
        process_error=$((process_error+1))
    fi
}
done

if [[ ${process_error} -gt 0 ]]; then
    die "Job releasing failed. See above error(s)."
fi