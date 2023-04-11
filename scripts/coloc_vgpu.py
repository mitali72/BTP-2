import paramiko
import csv
from pathlib import Path
import pandas as pd
import os
from csv import DictWriter

home = os.environ.get('HOME')

workload_coloc_factor={"ctr_dnn_torch": [1,2,4,8,12],
                       "particle_filter": [1,2,4,8,16,32],
                       "resnet50_pytorch":[1,2,4,8],
                       "resnet50_tf":[1,2,4,8],
                    #    "vec_add": [1,2,4,8,16,32,48],
                       "vgg16_pytorch" : [1,2,3,4] 
                       }

clients = [('vgpu-1','10.129.28.214'),('vgpu-2','10.129.28.242'), ('vgpu-3','10.129.28.72'),('vgpu-4','10.129.26.80')]
# Create object of SSHClient and
# connecting to SSH
ssh = paramiko.SSHClient()

# Adding new host key to the local
# HostKeys object(in case of missing)
# AutoAddPolicy for missing host key to be set before connection setup.
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

# ssh.connect('10.129.28.214', port=22, username='vgpu-1',
# 			password='1234', timeout=20)

for key in workload_coloc_factor:
    coloc_factor = workload_coloc_factor[key]
    for num_proc in coloc_factor:
        time_taken = -1e9
        if num_proc<=4:
            print("one on each launch")
            sel_clients = clients[:num_proc]
            for client in sel_clients:
                ssh.connect(client[1], port=22, username=client[0],password='1234', timeout=20)
                stdin, stdout, stderr = ssh.exec_command(f'bash /home/{client[0]}/mitali/workload_executables/{key}')
                time_taken = max(time_taken, float(stdout.read().decode("utf-8").splitlines()[0]))

            with open(os.path.join(home,f"mitali/profling/mps_4vgpu/{key}.csv"),"w+") as fthr:
                dictwriter_object = DictWriter(fthr, fieldnames=["NumOfProcesses","Throughput"])
                row = {"NumOfProcesses":num_proc, "Throughput": round(num_proc/time_taken,3)}
                dictwriter_object.writerow(row)
                
        else:
            print("divide")
# Execute command on SSH terminal
# using exec_command
stdin, stdout, stderr = ssh.exec_command('bash /home/vgpu-1/mitali/temp_executables/hello.sh')
cmd_output = stdout.read()
print(type(cmd_output))
print(cmd_output.decode("utf-8").splitlines()[0])