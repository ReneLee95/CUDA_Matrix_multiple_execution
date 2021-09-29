#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include "device_launch_parameters.h"

__global__ void kernel(void) { }

int main(void) {
	kernel << <1, 1 >> > ();
	printf("Hello, CUDA\n");

	return 0;
}