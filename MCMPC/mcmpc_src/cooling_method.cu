/*-- 
--*/
#include "../include/cooling_method.cuh"

float geometric_cooling(float init_st, int NUM_ITER, float rate){
    float ret;
    ret = powf(rate, NUM_ITER) * init_st;
    return ret;
}

float hyperbolic_cooling(float init_st, int NUM_ITER){
    float ret;
    ret = init_st / sqrtf(NUM_ITER + 1);
    return ret;
}