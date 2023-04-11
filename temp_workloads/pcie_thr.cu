#include <cuda_runtime.h>
#include <stdio.h>

#define BLOCK_SIZE 512

__global__ void kernel(float *d_out, float *d_in) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    d_out[i] = d_in[i];
}

int main() {
    float *h_in, *h_out;
    float *d_in, *d_out;
    int size = 1 << 15; // 1MB
     printf("%d\n",size);

    cudaMallocHost(&h_in, size);
    cudaMallocHost(&h_out, size);
    cudaMalloc(&d_in, size);
    cudaMalloc(&d_out, size);

    // Initialize host memory
    for (int i = 0; i < size; i++) {
        h_in[i] = (float)i;
        // printf("%d\n",i);
        
    }
    // printf("hello\n");
    // Copy host memory to device memory
    cudaMemcpy(d_in, h_in, size, cudaMemcpyHostToDevice);

    // Launch kernel
    kernel<<<size/BLOCK_SIZE, BLOCK_SIZE>>>(d_out, d_in);

    // Copy device memory to host memory
    cudaMemcpy(h_out, d_out, size, cudaMemcpyDeviceToHost);

    cudaFree(d_in);
    cudaFree(d_out);
    // cudaFreeHost(h_in);
    // cudaFreeHost(h_out);

    return 0;
}
