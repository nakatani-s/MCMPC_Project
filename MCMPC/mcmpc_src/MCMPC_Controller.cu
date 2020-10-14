/*--
    This File include
--*/
#include <time.h>
#include "../include/MCMPC_Controller.cuh"



void set_GPU_constant_values(const float *q, const float *r, const float *sys_pr, const float *inp_cntrnt, const float *st_cntrnt){
    cudaMemcpyToSymbol(d_Q, &q, DIM_Q * sizeof(float));
    cudaMemcpyToSymbol(d_R, &r, DIM_R * sizeof(float));
    cudaMemcpyToSymbol(d_param, &sys_pr, NUM_OF_SYS_PARAMETERS * sizeof(float));
    cudaMemcpyToSymbol(output_constraint, &st_cntrnt, NUM_OF_S_CONSTRAINT * sizeof(float));
    printf("#Successful copy of parameters from host to device d_param == %f\n",sys_pr[0]);
}

void set_GPU_constant_values_2(const float *q, const float *r, const float *qf, const float *rf, const float *sys_pr, const float *inp_cntrnt, const float *st_cntrnt){
    cudaMemcpyToSymbol(d_Q, &q, DIM_Q * sizeof(float));
    cudaMemcpyToSymbol(d_R, &r, DIM_R * sizeof(float));
    cudaMemcpyToSymbol(d_param, &sys_pr, NUM_OF_SYS_PARAMETERS * sizeof(float));
    cudaMemcpyToSymbol(input_constraint, &inp_cntrnt, NUM_OF_I_CONSTRAINT * sizeof(float));
    cudaMemcpyToSymbol(output_constraint, &st_cntrnt, NUM_OF_S_CONSTRAINT * sizeof(float));
    cudaMemcpyToSymbol(d_Qf, &qf, DIM_Qf * sizeof(float));
    cudaMemcpyToSymbol(d_Rf, &rf, DIM_Rf * sizeof(float));
    printf("#Successful copy of parameters from host to device");
}



__device__ float generate_u1(unsigned int id, curandState *state, float ave, float vr) {
    float u;
    curandState localState = state[id];

    u = curand_normal(&localState) * vr + ave;

    return u;
}


__global__ void MCMPC_GPU(float *h_state, SpecGPU gpu_info, curandState *devSt, DataMessanger *dvc, float *var, InputSequences *InpSeq){
    unsigned int id = threadIdx.x + blockDim.x * blockIdx.x;
    float U_dev[DIM_U][NUM_OF_HORIZON], Input_here[DIM_U];
    float Dev_State[DIM_X], dev_Diff_State[DIM_X];
    float Cost = 0;
    general_copy(Dev_State, h_state, DIM_X);
    for(int i = 0; i < NUM_OF_HORIZON; i++){
        for(int k = 0; k < DIM_U; k++){
            U_dev[k][i] = generate_u1(id, devSt, dvc[blockIdx.x].u[k][i], st_dev[k]); //入力を生成する関数はここ（同じファイル）に記述しないと機能しない
            Input_here[k] = generate_u1(id, devSt, 0, st_dev[k]);
        }
        // update predictive model by using random input
    
        get_current_diff_state(Dev_State, Input_here, d_param, dev_Diff_State);
        //printf("%f %f %f\n", Dev_State[0], Input_here[0],d_param[0]);
        euler_integrator_in_thread(Dev_State, dev_Diff_State, gpu_info.RATE_OF_CYCLE);
        Cost += get_stage_cost(Dev_State ,dev_Diff_State, Input_here, d_Q, d_R, output_constraint);
    }
    //printf("ID:%d Cost:%f\n",id, Cost);
    float exp_COST, S;
    S = Cost / gpu_info.LAMBDA;
    exp_COST  = expf(-S);
    thread_COST[threadIdx.x] = Cost;
    thread_exp_COST[threadIdx.x] = exp_COST;
    __syncthreads();
    if(threadIdx.x == 0){
        NO1 = 0;
        for(int i = 1; i < blockDim.x; i++){
            if(thread_COST[i] < thread_COST[NO1])
                NO1 = i;
        }
    }
    __syncthreads();
    if(threadIdx.x == NO1){
        dvc[blockIdx.x].L = thread_COST[NO1];
        dvc[blockIdx.x].W = thread_exp_COST[NO1];
        for(int i = 0; i < NUM_OF_HORIZON; i++){
            for(int k = 0; k < DIM_U; k++){
                dvc[blockIdx.x].u[k][i] = U_dev[k][i];
            }
        }
	//printf("ID: %d Value: %f\n", id, U_dev[0][10]);
        //dvc[blockIdx.x] = in_block;
    }
} 

void MCMPC_Controller(float *state, float *input, ControllerInfo &info_cont , SpecGPU gpu_info, ControllerParams param, DataMessanger *hst, DataMessanger *dvc, InputSequences *InpSeq, curandState *se){
    if(param.NUM_CYCLES == 0){
        cudaMemcpyToSymbol(d_Q, &Q, DIM_Q * sizeof(float));
        cudaMemcpyToSymbol(d_R, &R, DIM_R * sizeof(float));
        cudaMemcpyToSymbol(d_param, &system_params, NUM_OF_SYS_PARAMETERS * sizeof(float));
        cudaMemcpyToSymbol(output_constraint, &constraint_for_state, NUM_OF_S_CONSTRAINT * sizeof(float));
    }
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    InputSequences *device_InpSeq;
    float *h_state;
    cudaMalloc(&device_InpSeq, DIM_U * sizeof(InputSequences));
    cudaMalloc(&h_state,DIM_X * sizeof(float));
    cudaMemcpy(h_state, state, DIM_X*sizeof(float), cudaMemcpyHostToDevice); //状態量をデバイスで使用する変数にコピー
    
    float variance[DIM_U];
    //variance = (float*)malloc(DIM_U * sizeof(float));
    printf("Function: %f\n", hst[10].u[0][10]);
    /* Iterate Predction Process */
    for(int i = 0; i < gpu_info.ITERATIONS; i++){
        switch(COOLING_PATTERN){
            case 1:
                for(int k = 0; k < DIM_U; k++){
                    variance[k] = geometric_cooling(gpu_info.INIT_VARIANCE[k], i, gpu_info.COOLING_RATES[k]);
                }
                break;
            case 2:
                for(int k = 0; k < DIM_U; k++){
                    variance[k] = hyperbolic_cooling(gpu_info.INIT_VARIANCE[k], i);
                }
                break; 
            default:
                for(int k = 0; k < DIM_U; k++){
                    variance[k] = gpu_info.INIT_VARIANCE[k];
                }
                break;
                
        }
        cudaMemcpy(device_InpSeq, InpSeq, DIM_U * sizeof(InputSequences), cudaMemcpyHostToDevice);
        cudaMemcpyToSymbol(st_dev, &variance, DIM_U*sizeof(float));
        MCMPC_GPU<<<gpu_info.NUM_BLOCKS,gpu_info.TH_PER_BLS>>>(h_state, gpu_info, se, dvc, variance, InpSeq);
        cudaMemcpy(hst, dvc, gpu_info.NUM_BLOCKS * sizeof(DataMessanger),cudaMemcpyDeviceToHost); //ここでコピーしても記述されない

        switch(PREDICTIVE_METHOD){
            case 1:
                TOP1_sample_method(hst, gpu_info, InpSeq);
        }
        printf("Values From Function: %f CostFrom: %f  TOP_Input: %f\n", hst[10].u[0][0], hst[10].L, InpSeq[0].u[0]);
    }
    //hst[10].u[0][10] = 1.0;
    //printf("Values From Function: %f %f\n", hst[10].u[0][10], variance[0]);
}
