/*--
    Relate MCMPC_Controller.cu
--*/ 
#include <stdio.h>
#include <cuda.h>
#include <curand_kernel.h>
#include "MCMPC_all_Header.cuh"
// #include "../MCMPCtoolkit.cuh"
//#include "Initializer.cuh"
#include "generate_random_input.cuh"
#include "cooling_method.cuh"
#include "MonteCarloMethod.cuh"

#ifndef MCMPC_CONTROLLER_CUH
#define MCMPC_CONTROLLER_CUH

__shared__ int NO1;
__shared__ float thread_COST[NUM_OF_THREAD_PER_BLOCKS], thread_exp_COST[NUM_OF_THREAD_PER_BLOCKS];
__device__ float d_param[NUM_OF_SYS_PARAMETERS];
__device__ float d_Q[DIM_Q], d_R[DIM_R], d_Qf[DIM_Qf], d_Rf[DIM_Rf];
__device__ float input_constraint[NUM_OF_I_CONSTRAINT], output_constraint[NUM_OF_S_CONSTRAINT];
__device__ float st_dev[DIM_U];
// __shared__ 

__global__ void setup_kernel1(curandState *state,int seed);

void set_GPU_constant_values(const float *q, const float *r, const float *sys_pr, const float *inp_cntrnt, const float *st_cntrnt);

void set_GPU_constant_values_2(const float *q, const float *r, const float *qf, const float *rf, const float *sys_pr, const float *inp_cntrnt, const float *st_cntrnt);

void MCMPC_Controller(float *state, ControllerInfo &info_cont , SpecGPU gpu_info, ControllerParams param, DataMessanger *hst, DataMessanger *device, InputSequences *InpSeq, curandState *se);

#endif
