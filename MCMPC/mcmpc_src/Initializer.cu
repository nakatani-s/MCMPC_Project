/*-- 
--*/
#include<stdio.h>
#include "../include/Initializer.cuh"

void Initialize_state(float *state){
    for(int i = 0; i < DIM_X; i++){
        state[i] = initial_state[i];
    }
}

void Initialize_input(float *input){
    for(int i = 0; i < DIM_U; i++){
        input[i] = initial_input[i];
    }
}

void Initialize_diff_state(float *diff_st){
    for(int i = 0; i < DIM_X; i++){
        diff_st[i] = initial_diff_state[i];
    }
}


int countBlocks(int a, const int b) {
	int num;
	num = a / b;
	if (a < b || a % b > 0)
		num++;
	return num;
}



void Initialize(float *state, float *input, float *diff_st, SpecGPU &a, ControllerParams &get_param, DataMessanger *hst, InputSequences *inp_sq){
    Initialize_state(state);
    Initialize_input(input);
    Initialize_diff_state(diff_st);
    
    a.NUM_SAMPLES     = NUM_OF_BLOCKS * NUM_OF_THREAD_PER_BLOCKS;
    a.NUM_BLOCKS      = NUM_OF_BLOCKS;
    a.TH_PER_BLS      = NUM_OF_THREAD_PER_BLOCKS;
    a.NUM_PRED_STEPS  = NUM_OF_HORIZON;
    a.ITERATIONS      = NUM_OF_ITERATIONS;
    a.NUM_SEEDS       = countBlocks(NUM_OF_BLOCKS * NUM_OF_THREAD_PER_BLOCKS * NUM_OF_HORIZON, NUM_OF_THREAD_PER_BLOCKS);
    a.RATE_OF_CYCLE   = CONTROL_CYCLE;
    a.LAMBDA          = Clambda;
    for(int i = 0; i < DIM_U; i++){
        a.INIT_VARIANCE[i] = INITIAL_SIGMA[i];
        a.COOLING_RATES[i] = RATE_OF_COOLING[i];
    }

    for(int i = 0; i < NUM_OF_SYS_PARAMETERS; i++){
        get_param.d_param[i] = system_params[i];
    }
    for(int i = 0; i < DIM_Q; i++){
        get_param.d_Q[i] = Q[i];
    }
    for(int i = 0; i < DIM_R; i++){
        get_param.d_R[i] = R[i];
    }
    for(int i = 0; i < NUM_OF_I_CONSTRAINT; i++){
        get_param.d_I_constraint[i] = constraint_for_input[i];
    }
    for(int i = 0; i < NUM_OF_S_CONSTRAINT; i++){
        get_param.d_S_constraint[i] = constraint_for_state[i];
    }
    DataMessanger in_func;
    in_func.L = 0.0f;
    in_func.W = 0.0f;
    in_func.IT_L = 0.0f;

    for(int i = 0; i < NUM_OF_HORIZON; i++){
        for(int k = 0; k < DIM_U; k++){
            in_func.u[k][i] = initial_input[k];
            inp_sq[k].u[i] = initial_input[k];
        }
    }
    for(int i = 0; i < NUM_OF_BLOCKS; i++){
        hst[i] = in_func;
    }
}



