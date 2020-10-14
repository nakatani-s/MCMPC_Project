/*-- 
--*/
#include "../include/Generic_function.cuh"
__device__ void general_copy(float *af, float *be, int dims){
    for(int i = 0; i < dims; i ++){
        be[i] = af[i];
    }
}