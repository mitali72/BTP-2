from pssh.clients import ParallelSSHClient
from pssh.config import HostConfig
import os
import csv

workload_coloc_factor={
                        "ctr_dnn_torch": 8,
                    #    "particle_filter": 32,
                    #    "resnet50_pytorch":8,
                    #    "vec_add": 40,
                       "vgg16_pytorch" : 4,
                       "vgg16_tf": 2,
                    "video_recog_tf" : 4,
                    "text_classification_tf": 4,
                    "text_classification_pytorch": 4
                       }

if __name__=="__main__":
        
    hosts = ['10.129.28.214', '10.129.28.242', '10.129.28.72', '10.129.26.80']
    # hosts = ['10.129.28.214']
    host_config = [
    HostConfig(user='vgpu-1',
            password='1234'),
    HostConfig(user='vgpu-2',
            password='1234'),
    HostConfig(user='vgpu-3',
            password='1234'),
    HostConfig(user='vgpu-4',
            password='1234'),
]
    client = ParallelSSHClient(hosts, host_config=host_config)

    output = client.run_command('source ~/mitali/scripts/start_mps.sh')
    client.join()

    for key in workload_coloc_factor:

        home = os.environ.get('HOME')
        directory = f"mitali/profiling/coloc_homo_max/{key}/latency/"
        directory = os.path.join(home,directory)

        if not os.path.exists(directory):
            os.makedirs(directory)
        with open(os.path.join(directory,"mps_4vgpu.csv"),"w") as fthr:
            dictwriter_object = csv.DictWriter(fthr, fieldnames=["Cores", "Latency"])
            dictwriter_object.writeheader()

        coloc_factor = workload_coloc_factor[key]

        for i in range(100,110,10):
            print(key, i)
            time_taken = -1e9
            
            rem = coloc_factor%4
            n = coloc_factor//len(hosts)
            n_vm = []
            for i in range(4):
                if rem!=0:
                    n_vm.append(str(n+1))
                    rem -= 1
                else:
                    n_vm.append(str(n))

            client.hosts = hosts
            # print(n_vm)
            output = client.run_command(f"~/mitali/workload_executables/{key} {i} {n}")
            # output = client.run_command('~/mitali/workload_executables/%s %s %s',host_args = ((key,str(i),n_vm[0]),(key,str(i),n_vm[1]), (key, str(i), n_vm[2]), (key,str(i),n_vm[3]), ))
            client.join()

            for host_output in output:
                # print(host_output)
                for line in host_output.stdout:
                    print(line)
                    time_taken = max(time_taken, float(line))
                    # print(time_taken)
                for line in host_output.stderr:
                    print(line)

            with open(os.path.join(directory,"mps_4vgpu.csv"),"a") as fthr:
                dictwriter_object = csv.DictWriter(fthr, fieldnames=["Cores","Latency"])
                row = {"Cores":i, "Latency": time_taken}
                dictwriter_object.writerow(row)