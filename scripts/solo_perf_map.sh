#!/bin/bash
# Colocated functions n
# run in profiling directory
TIMEFORMAT=%R
eval "$(conda shell.bash hook)"
conda activate my_tf
# batch_max=32
# mem=$((16384/8))

direc="$HOME/mitali/workload_executables/*"
for file in $direc
do
    filename=$(basename "$file")
    echo "cores, time" > $HOME/mitali/profiling/solo/latency/${filename}.csv
    for((i=10;i<=100;i=i+10))
    do
        # cores=$((100/$i))
        source ~/mitali/scripts/setup_gpu_limit.sh $i%
        # echo $CUDA_MPS_ACTIVE_THREAD_PERCENTAGE
        echo "evaluating for workload = ${filename} and cores% = ${i}"
        # cmd="${file}"
        cmd="nsys profile --cpuctxsw system-wide --trace cuda,cudnn --cuda-memory-usage true --cuda-um-cpu-page-faults true --cuda-um-gpu-page-faults true --gpu-metrics-device all -o ${filename}_${i}.nsys-rep --force-overwrite true --stats true ${file}"
        # start=$(date +%s.%3N)
        eval $cmd
        # end=$(date +%s.%3N)
        # runtime=$(echo "$end - $start" | bc)
        line="${i},${runtime}"
        # echo -e $line >> /home/ub-11/mitali/profiling/solo/${filename}.csv
        sqlite3 -header -csv ${filename}_${i}.sqlite "SELECT rawTimestamp, JSON_EXTRACT(data, '$.SM Active') as SMsActive, JSON_EXTRACT(data, '$.PCIe TX Throughput') as PCIeTxThr, JSON_EXTRACT(data, '$.PCIe RX Throughput') as PCIeRxThr from GENERIC_EVENTS" > $HOME/mitali/profiling/solo/gpu_util/${filename}_${i}.csv
        rm ${filename}_${i}.nsys-rep ${filename}_${i}.sqlite
    done
done
python3 $HOME/mitali/scripts/csv_avg.py