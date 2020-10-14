/*-- 
--*/
// #include "MCMPC_all_Header.cuh"
#include "../MCMPCtoolkit.cuh"
__device__ void general_copy(float *af, float *be, int dims);
__device__ float input_saturation(float in, float *constraint, int k);