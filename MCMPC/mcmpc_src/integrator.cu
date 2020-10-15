/*-- 
--*/
#include "../include/integrator.cuh"
__device__ void euler_integrator_in_thread(float *state, float *diff_state, float control_cycle){
    // Update state with Euler integral in threads
    //int N_ = sizeof state / sizeof *state;
    for(int i = 0; i < DIM_X; i++){
        state[i] += diff_state[i] * control_cycle;
    }
}

__host__ __device__ void simple_integrator(float *diff_state, float c_sec, float *yp_vector){
    for(int i = 0; i < DIM_X; i++){
        yp_vector[i] = diff_state[i] * c_sec;
    }
}
__host__ __device__ void Runge_kutta_45_for_Secondary_system(float *state, float *input, float *param, float c_sec){
    float diff_state[DIM_X], yp_1[DIM_X], next_state[DIM_X];
    get_current_diff_state(state, input, param, diff_state);
    simple_integrator(diff_state, c_sec, yp_1);
    for(int i = 0; i < DIM_X; i++){
        next_state[i] = state[i] + yp_1[i] * (c_sec / 2);
    }

    float yp_2[DIM_X];
    get_current_diff_state(next_state, input, param, diff_state);
    simple_integrator(diff_state, c_sec, yp_2);
    for(int i = 0; i < DIM_X; i++){
        next_state[i] = state[i] + yp_2[i] * (c_sec / 2);
    }

    float yp_3[DIM_X];
    get_current_diff_state(next_state, input, param, diff_state);
    simple_integrator(diff_state, c_sec, yp_3);
    for(int i = 0; i < DIM_X; i++){
        next_state[i] = state[i] + yp_3[i] * c_sec;
    }

    float yp_4[DIM_X];
    get_current_diff_state(next_state, input, param, diff_state);
    simple_integrator(diff_state, c_sec, yp_4);

    for(int i = 0; i < DIM_X; i++){
        state[i] += (yp_1[i] + 2*yp_2[i] + 2*yp_3[i] + yp_4[i]) / 6;
    }

}