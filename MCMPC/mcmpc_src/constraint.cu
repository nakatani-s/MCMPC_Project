/*-- 
--*/
#include "../include/constraint.cuh" 

__host__ __device__ float state_constraint_barrier(float st, float min, float max, int TYPE){
    float add = 0;
    float med = 0;
    switch(CONSTRAINT_TYPE){
        case 1:
            med = (max + min)/2;
            if(med < st){
                add += 1/(powf((max - st),2));
                if(max < st){
                    add += FLT_MAX;
                }
            }else{
                add += 1/(powf((min - st),2));
                if(st < min){
                    add += FLT_MAX;
                }
            }
            break;
        case 2:
            med = (max + min) /2;
            if(med < st){
                add += -logf(max-st);
                if(max < st){
                    add += FLT_MAX;
                }
            }else{
                add += -logf(st - min);
                if(st < min){
                    add += FLT_MAX;
                }
            }
            break;
        default:
            if( st < min ){
                add += FLT_MAX;
            }
            if( max < st){
                add += FLT_MAX;
            }
            break;
    }

    return add;
}

