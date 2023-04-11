#!/bin/bash
# Colocated functions n
# run in profiling directory
TIMEFORMAT=%R
# n=$1
# mem=$((16384/4))
# cores=$((100/4))
eval "$(conda shell.bash hook)"
conda activate my_tf
# batch_max=32
direc='/home/ub-11/mitali/workload_executables/*'
for file in $direc
do
    # echo $file
    filename=$(basename "$file")
    echo "evaluating for workload = ${filename%.*}"
    nsight_cmd="nsys profile --cpuctxsw system-wide --trace cuda,cudnn --cuda-memory-usage true --cuda-um-cpu-page-faults true --cuda-um-gpu-page-faults true --gpu-metrics-device all -o ubench_${filename%.*}.nsys-rep --force-overwrite true --stats true ${file}"
    eval $nsight_cmd
    wait

    sqlite3 -header -csv ubench_${filename%.*}.sqlite "SELECT rawTimestamp, JSON_EXTRACT(data, '$.SM Active') as SMsActive, JSON_EXTRACT(data, '$.PCIe TX Throughput') as PCIeTxThr, JSON_EXTRACT(data, '$.PCIe RX Throughput') as PCIeRxThr from GENERIC_EVENTS" > ubench_${filename%.*}.csv
    wait
done
# for((batch=${batch_max};batch<=${batch_max};batch=2*batch))
# do  
#     echo "evaluating for batch size = ${batch}"
#     nsight_cmd="nsys profile --cpuctxsw system-wide --trace cuda,cudnn --cuda-memory-usage true --cuda-um-cpu-page-faults true --cuda-um-gpu-page-faults true --gpu-metrics-device all -o ubench_resnet50_pytorch_${batch}.nsys-rep --force-overwrite true --stats true python3 /home/ub-11/mitali/workloads/resnet50_pytorch.py --batch-size ${batch}"
#     eval $nsight_cmd
#     wait

#     sqlite3 -header -csv ubench_resnet50_pytorch_${batch}.sqlite "SELECT rawTimestamp, JSON_EXTRACT(data, '$.SM Active') as SMsActive, JSON_EXTRACT(data, '$.PCIe TX Throughput') as PCIeTxThr, JSON_EXTRACT(data, '$.PCIe RX Throughput') as PCIeRxThr from GENERIC_EVENTS" > ubench_resnet50_pytorch_${batch}.csv
#     wait
# done