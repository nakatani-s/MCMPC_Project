/*-- 
--*/

#ifndef DATASTRUCTURES_CUH
#define DATASTRUCTURES_CUH

typedef struct{
    float objValues;
    float GPU_time;
}ControllerInfo;

typedef struct{
    int NUM_SAMPLES;
    int NUM_SEEDS;
    int NUM_BLOCKS;
    int TH_PER_BLS;
    int NUM_PRED_STEPS;
    int ITERATIONS;
    float RATE_OF_CYCLE;
    float INIT_VARIANCE[DIM_U];
    float COOLING_RATES[DIM_U];
    float LAMBDA; //special constant
}SpecGPU;


typedef struct{
    int NUM_CYCLES;
    float d_param[NUM_OF_SYS_PARAMETERS];
    float d_Q[DIM_Q];
    float d_R[DIM_R];
    float d_I_constraint[NUM_OF_I_CONSTRAINT];
    float d_S_constraint[NUM_OF_S_CONSTRAINT];
}ControllerParams;

#endif