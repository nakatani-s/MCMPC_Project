/*-- 
--*/
#include "../MCMPCtoolkit.cuh"
#include "MyFunctions.cuh"
__device__ void euler_integrator_in_thread(float *state, float *diff_state, float control_cycle);
__host__ __device__ void Runge_kutta_45_for_Secondary_system(float *state, float *input, float *param, float c_sec);
 