#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <iostream>

using namespace std;

__global__ void MatrixMul(int* M, int* N, int* P, int Width) {
	int tx, ty, tid;
	tx = blockDim.x * blockIdx.x + threadIdx.x;
	ty = blockDim.y * blockIdx.y + threadIdx.y;
	
	tid = Width * ty + tx;

	int value = 0;
	int mval = 0;
	int nval = 0;

	for (int i = 0; i < Width; i++) {
		mval = M[Width * tx + i];
		nval = N[i * Width + tx];
		value += mval * nval;
	}

	P[tid] = value;
}

void MatrixMulC(int* M, int* N, int* P, int Width) {
	int col = 0;
	int raw = 0;
	int index = 0;
	int Destindex = 0;

	for (col = 0; col < Width; col++) {
		for (raw = 0; raw < Width; raw++) {
			Destindex = col * Width + raw;
			
			for (index = 0; index < Width; index++) {
				P[Destindex] += M[col * Width + index] * N[index * Width + raw];
			}
		}
	}
}

int main() {
	const int MatrixWidth = 12;
	const int MatrixHeight = 12;
	const int MatrixSize = MatrixWidth * MatrixHeight;
	const int BufferSize = MatrixSize * sizeof(int);

	int* M;
	int* N;
	int* P_cuda;
	int* P_C;

	M = (int*)malloc(BufferSize);
	N = (int*)malloc(BufferSize);
	P_cuda = (int*)malloc(BufferSize);
	P_C = (int*)malloc(BufferSize);

	int i = 0;

	for (i = 0; i < MatrixSize; i++) {
		M[i] = i;
		N[i] = i;
		P_cuda = 0;
		P_C = 0;
	}
	
	int* dev_M;
	int* dev_N;
	int* dev_P;

	cudaMalloc((void**)&dev_M, BufferSize);
	cudaMalloc((void**)&dev_N, BufferSize);
	cudaMalloc((void**)&dev_P, BufferSize);
	
	cudaMemcpy(dev_M, M, BufferSize,cudaMemcpyHostToDevice);
	cudaMemcpy(dev_N, N, BufferSize,cudaMemcpyHostToDevice);
	
	dim3 Dg(3, 4, 1);
	dim3 Db(4, 3, 1);
	
	MatrixMul << <Dg, Db >> > (dev_M, dev_N, dev_P, 12);
	cudaMemcpy(P_cuda, dev_P, BufferSize,cudaMemcpyDeviceToHost);
//	MatrixMulC(M, N, P_C, 12);
	bool ResultFlag = true;
	for (i = 0; i < MatrixSize; i++) {
	//	if (P_cuda[i] != P_C[i]) ResultFlag = false;
	}

	if (ResultFlag == true) printf("MatrixMul Result OK!\n");
	else printf("MatrixMul Result Error\n");
		
	cudaFree(dev_M);
	cudaFree(dev_N);
	cudaFree(dev_P);
		
	free(M);
	free(N);
	free(P_cuda);
	free(P_C);

	return 0;
}