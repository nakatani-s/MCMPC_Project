/*-- 
--*/
#include "../include/integrator.cuh"
__device__ void euler_integrator_in_thread(float *state, float *diff_state, float control_cycle){
    // Update state with Euler integral in threads
    int N_ = sizeof state / sizeof *state;
    for(int i = 0; i < N_; i++){
        state[i] += diff_state[i] * control_cycle;
    }
}