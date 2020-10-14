/*-- 
--*/
#include "../include/Generic_function.cuh"
__device__ void general_copy(float *af, float *be, int dims){
    for(int i = 0; i < dims; i ++){
        af[i] = be[i];
    }
}

__device__ float input_saturation(float in, float *constraint, int k){
        float ret = in;
        if( in <= constraint[k * DIM_U]){
            ret = constraint[k * DIM_U];
        }
        if( constraint[k * DIM_U + 1]){
            ret = constraint[k * DIM_U +1];
        }
        return ret;
}