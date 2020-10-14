/*--
    The substance of the following functions are described in /(user_making_directory)/function/MyFunctions.cu
--*/
#include <math.h>
#include <cuda.h>
#include "constraint.cuh"
__host__ __device__ void get_current_diff_state(float *state, float *input, float *param, float *diff_state);
__host__ __device__ float get_stage_cost(float *state, float *diff_state, float *input, float *q, float *r, float *state_constraint);