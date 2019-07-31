declare -a pid_list
num_proc_per_gpu=4
for (( i=0; i<$num_proc_per_gpu; i++ ));
do
{
    sleep $(($i))
    ech
}&
pid=$!
pid_list[$i]=$pid
echo $pid
done

for (( i=0; i<$num_proc_per_gpu; i++ ));
do
{
    echo $i
    pid=${pid_list[$i]}
    wait $pid
    if [[ $? -ne 0 ]]; then
        echo "${simulation_executable} failed. See above error."
        #echo ${pid_list[@]}
        #kill ${pid_list[@]}
        #pkill -P $$
        kill -TERM -- -$$
        #exit 2
    fi
}
done