/*--
    Messanger.cuh
--*/
#include "../MCMPCtoolkit.cuh" 
#ifndef MESSANGER_CUH
#define MESSANGER_CUH
typedef struct{
    int Best_ID;
    float L;
    float W;
    float IT_L;
    float u[DIM_U][NUM_OF_HORIZON];
}DataMessanger;

typedef struct{
    float u[NUM_OF_HORIZON];
}InputSequences;

#endif