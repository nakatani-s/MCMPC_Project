/*-- 
--*/
#include <cuda.h>
#include <curand_kernel.h>

__global__ void setup_kernel(curandState *state,int seed);
__device__ float generate_u(unsigned int id, curandState *state, float ave, float vr);