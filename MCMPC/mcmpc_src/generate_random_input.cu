/*-- 
--*/
#include "../include/generate_random_input.cuh"

/*#define CUDA_CALL(x) do { if((x) != cudaSuccess) { \
    printf("Error at %s:%d\n",__FILE__,__LINE__); \
    return EXIT_FAILURE;}} while(0)*/
    
__global__ void setup_kernel(curandState *state,int seed) {
    unsigned int id = threadIdx.x + blockIdx.x * blockDim.x;
    /* Each thread gets same seed, a different sequence number,
     no offset */
    curand_init(seed, id, 0, &state[id]);
}

__device__ float generate_u(unsigned int id, curandState *state, float ave, float vr) {
    float u;
    //	printf("id:%d",id);

    //For Efficiency
    curandState localState = state[id];

    u = curand_normal(&localState) * vr + ave;

    return u;
}
