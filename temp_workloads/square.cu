#include <cuda_runtime.h>
#include <iostream>

__global__ void square_array(int *a, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < n) {
        a[idx] = a[idx] * a[idx];
    }
}

int main() {
    int n = 100;
    int *a, *d_a;
    cudaMalloc(&d_a, n * sizeof(int));
    a = new int[n];

    // Initialize the input array with random values
    for (int i = 0; i < n; i++) {
        a[i] = rand() % 100;
    }

    cudaMemcpy(d_a, a, n * sizeof(int), cudaMemcpyHostToDevice);

    // Launch the kernel on the GPU with high occupancy
    for(int i=0;i<=5000000;i++)
    {
        square_array<<<(n + 255) / 256, 256>>>(d_a, n);
    }
    
    cudaMemcpy(a, d_a, n * sizeof(int), cudaMemcpyDeviceToHost);

    // Print the results
    // for (int i = 0; i < n; i++) {
    //     std::cout << a[i] << " ";
    // }

    cudaFree(d_a);
    delete[] a;
    return 0;
}
