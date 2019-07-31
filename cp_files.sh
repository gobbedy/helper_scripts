#!/bin/bash

remote_manifest_file=$1
local_manifest_file=$2
destination=$3
cluster=$4
start_index=$5

# set up sshfs for remote mount
mnt_dir=~/mnt/$cluster
fusermount -u $mnt_dir
mkdir $mnt_dir
sshfs -o allow_other -o follow_symlinks -o ssh_command="ssh -i ~/.ssh/id_rsa" gobbedy@${cluster}.computecanada.ca:/ $mnt_dir

# create local directory where local files will be copied to
mkdir $destination

# grab files and add mount prefix
remote_manifest_file="${mnt_dir}${remote_manifest_file}"
logfiles=($(cat ${remote_manifest_file}))
logfiles=( "${logfiles[@]/#/${mnt_dir}}" )

# copy files to local destination
num_files_to_copy="${#logfiles[@]}"

for (( i=0; i<$num_files_to_copy; i++ )); do
  logfile="${logfiles[i]}"
  log_basename=`basename $logfile`
  log_number=$((i + start_index))
  local_basename="${log_basename%.*}_${log_number}.log"
  local_logfile_name=$destination/${local_basename}
  cp $logfile $local_logfile_name
  echo $local_logfile_name >> $local_manifest_file
done
