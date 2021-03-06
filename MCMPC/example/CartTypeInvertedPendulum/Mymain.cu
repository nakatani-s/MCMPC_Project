/*-- 
--*/
#include <iostream>
#include <stdio.h>
#include <time.h>
#include "../../include/MCMPC_all_Header.cuh"
#include "../../include/Initializer.cuh"
#include "../../include/MCMPC_Controller.cuh"

ControllerInfo _controller;
SpecGPU get_info;
ControllerParams get_param;
DataMessanger *host_, *device_;
InputSequences *Input_Seq;

int main(int argc, char **argv){
    int number;
    time_t now = time(NULL);
    struct tm *pnow = localtime(&now);
    number = pnow->tm_sec;

    float *State, *Input, *Diff_State;
    curandState *seedMaker;
    cudaMalloc((void**)&seedMaker, NUM_OF_BLOCKS * NUM_OF_THREAD_PER_BLOCKS * DIM_U * NUM_OF_HORIZON  * sizeof(curandState));
    setup_kernel<<<NUM_OF_BLOCKS * NUM_OF_HORIZON * DIM_U, NUM_OF_THREAD_PER_BLOCKS>>>(seedMaker, number);
    State = (float*)malloc(DIM_X * sizeof(float));
    Input = (float*)malloc(DIM_U * sizeof(float));
    Diff_State = (float*)malloc(DIM_X * sizeof(float));
    host_ = (DataMessanger*)malloc(NUM_OF_BLOCKS * sizeof(DataMessanger));
    cudaMalloc(&device_ , NUM_OF_BLOCKS * sizeof(DataMessanger));
    Input_Seq = (InputSequences*)malloc(DIM_U * sizeof(InputSequences));
    Initialize(State, Input, Diff_State, get_info, get_param, host_, Input_Seq);
    cudaMemcpy(device_, host_, NUM_OF_BLOCKS*sizeof(DataMessanger),cudaMemcpyHostToDevice);
    get_param.NUM_CYCLES = 0;
    printf("hoge\n");
    InputSequences *device_InpSeq;
    cudaMallocManaged((void**)&device_InpSeq, DIM_U * sizeof(InputSequences));
    float in_h_param[NUM_OF_SYS_PARAMETERS];
    for( int i = 0; i < NUM_OF_SYS_PARAMETERS; i++){
        in_h_param[i] = system_params[i];
    }

    switch(WITH_TERMINAL_COST){
        case 1:
            set_GPU_constant_values(Q, R, system_params, constraint_for_input, constraint_for_state);
            break;
        case 2:
            set_GPU_constant_values_2(Q, R, Qf, Rf, system_params, constraint_for_input, constraint_for_state);
            break;
        default:
            printf("#Fatal error in designing cost function");
            break;
    }
    
    printf("|--------Start Simulation Loop--------|");
    printf("InitValues : %f\n",host_[10].u[1][10]);
    for(int i = 0; i < 500; i++){
        
        MCMPC_Controller(State, _controller, get_info, get_param, host_, device_, Input_Seq, seedMaker, device_InpSeq);
        cudaMemcpy(host_, device_, NUM_OF_BLOCKS*sizeof(DataMessanger),cudaMemcpyDeviceToHost);
        get_param.NUM_CYCLES = i;
        copy_current_input(Input, Input_Seq);
        printf("InputFromMain : %f CostFromMain: %f Theta: %f x: %f dx: %f dth: %f\n",Input[0] ,host_[0].L, State[1], State[0], State[2], State[3]);
        // Runge_kutta_45_for_Secondary_system(State, Input, in_h_param, get_info.RATE_OF_CYCLE);
        get_current_diff_state(State, Input, in_h_param, Diff_State);
        euler_integrator_in_thread(State, Diff_State, get_info.RATE_OF_CYCLE);
        Shift_Input_Sequences(Input_Seq);
    }
}
