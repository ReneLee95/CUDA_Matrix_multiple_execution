#include <iostream>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <vector>

using namespace std;

vector<int> v;

__global__ void KernelFunction(int a, int b, int c) {
	int sum = a + b + c;  
}

int main() {
	KernelFunction << <6, 6 >> > (1, 2, 3);

	cout << "success" << endl;

	for (int i = 0; i < v.size(); i++) {
		cout << v[i] << endl;
	}

	return 0;
}