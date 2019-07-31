#!/bin/bash
set -o pipefail
me=$(basename ${0%%@@*})
full_me=${0%%@@*}

# check if item is contained in a list
# usage:
# contains anItem alist
# partial credit: https://stackoverflow.com/a/8063398/8112889 (see "succinct" comment)
# rest of credit: https://askubuntu.com/a/995110/827650 (for passing list as argument)
contains() {
   local str="$1"
   shift
   local arr=("$@")
   [[ " ${arr[@]} " =~ " $str " ]] && return 0 || return 1
}

gpu=yes
cpu=yes
skip_list=()
while [[ "$1" == -* ]]; do
  case "$1" in
    --gpu)
      # gpu only
      gpu=yes
      cpu=no
      shift 1
    ;;
    --cpu)
      # cpu only
      gpu=no
      cpu=yes
      shift 1
    ;;
    --skip)
      # cpu only
      skip_list+=($2)
      shift 2
    ;;
    -*)
      echo "Invalid option $1"
      exit 1
    ;;
  esac
done


node_prefix=$(hostname | cut -c1-3)
if [[ $node_prefix == "hel" ]]; then
   local_cluster=helios
elif [[ $node_prefix == "nia" ]]; then
   local_cluster=niagara
elif [[ $node_prefix == "bel" ]]; then
   local_cluster=beluga
elif [[ $node_prefix == "ced" ]]; then
   local_cluster=cedar
elif [[ $node_prefix == "gra" ]]; then
   local_cluster=graham
elif [[ $node_prefix == ip* ]]; then
   local_cluster=mammouth
else
  echo "WARNING: local cluster unsupported"
fi

echo "LevelFS"

if ! contains "beluga" "${skip_list[@]}"; then

    if [[ ${cpu} == "yes" ]]; then
        echo "Beluga CPU rrg"
        if [[ ${local_cluster} == "beluga" ]]; then
            sshare -l -A rrg-yymao_cpu -u '-' -no LevelFS
        else
            ssh gobbedy@beluga.computecanada.ca sshare -l -A rrg-yymao_cpu -u '-' -no LevelFS
        fi
    fi

    if [[ ${cpu} == "yes" ]]; then
        echo "Beluga CPU def"
        if [[ ${local_cluster} == "beluga" ]]; then
            sshare -l -A def-yymao_cpu -u '-' -no LevelFS
        else
            ssh gobbedy@beluga.computecanada.ca sshare -l -A def-yymao_cpu -u '-' -no LevelFS
        fi
    fi

    if [[ ${gpu} == "yes" ]]; then
        echo "Beluga GPU (def)"
        if [[ ${local_cluster} == "beluga" ]]; then
            sshare -l -A def-yymao_gpu -u '-' -no LevelFS
        else
            ssh gobbedy@beluga.computecanada.ca sshare -l -A def-yymao_gpu -u '-' -no LevelFS
        fi
    fi
fi

if ! contains "cedar" "${skip_list[@]}"; then

    if [[ ${cpu} == "yes" ]]; then
        echo "Cedar CPU rrg"
        if [[ ${local_cluster} == "cedar" ]]; then
            sshare -l -A rrg-yymao_cpu -u '-' -no LevelFS
        else
            ssh gobbedy@cedar.computecanada.ca sshare -l -A rrg-yymao_cpu -u '-' -no LevelFS
        fi
    fi

    if [[ ${cpu} == "yes" ]]; then
        echo "Cedar CPU def"
        if [[ ${local_cluster} == "cedar" ]]; then
            sshare -l -A def-yymao_cpu -u '-' -no LevelFS
        else
            ssh gobbedy@cedar.computecanada.ca sshare -l -A def-yymao_cpu -u '-' -no LevelFS
        fi
    fi

    if [[ ${gpu} == "yes" ]]; then
        echo "Cedar GPU rrg"
        if [[ ${local_cluster} == "cedar" ]]; then
            sshare -l -A rrg-yymao_gpu -u '-' -no LevelFS
        else
            ssh gobbedy@cedar.computecanada.ca sshare -l -A rrg-yymao_gpu -u '-' -no LevelFS
        fi
    fi

    if [[ ${gpu} == "yes" ]]; then
        echo "Cedar GPU def"
        if [[ ${local_cluster} == "cedar" ]]; then
            sshare -l -A def-yymao_gpu -u '-' -no LevelFS
        else
            ssh gobbedy@cedar.computecanada.ca sshare -l -A def-yymao_gpu -u '-' -no LevelFS
        fi
    fi
fi

if ! contains "graham" "${skip_list[@]}"; then
    if [[ ${gpu} == "yes" ]]; then
        echo "Graham GPU (def)"
        if [[ ${local_cluster} == "graham" ]]; then
            sshare -l -A def-yymao_gpu -u '-' -no LevelFS
        else
            ssh gobbedy@graham.computecanada.ca sshare -l -A def-yymao_gpu -u '-' -no LevelFS
        fi
    fi

    if [[ ${cpu} == "yes" ]]; then
        echo "Graham CPU (def)"
        if [[ ${local_cluster} == "graham" ]]; then
            sshare -l -A def-yymao_cpu -u '-' -no LevelFS
        else
            ssh gobbedy@graham.computecanada.ca sshare -l -A def-yymao_cpu -u '-' -no LevelFS
        fi
    fi
fi

if ! contains "mammouth" "${skip_list[@]}"; then
    if [[ ${cpu} == "yes" ]]; then
        echo "Mammouth CPU (def)"
        if [[ ${local_cluster} == ip* ]]; then
            sshare -l -A def-yymao_cpu -u '-' -no LevelFS
        else
            ssh gobbedy@mp2b.calculquebec.ca sshare -l -A def-yymao_cpu -u '-' -no LevelFS
        fi
    fi
fi

if ! contains "niagara" "${skip_list[@]}"; then
    if [[ ${cpu} == "yes" ]]; then
        echo "Niagara CPU (def)"
        if [[ ${local_cluster} == "niagara" ]]; then
            sshare -l -A def-yymao -u '-' -no LevelFS
        else
            ssh gobbedy@niagara.computecanada.ca sshare -l -A def-yymao -u '-' -no LevelFS
        fi
    fi
fi