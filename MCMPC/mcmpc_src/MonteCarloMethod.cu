/*-- 
--*/
#include "../include/MonteCarloMethod.cuh"

int search_best_ID(DataMessanger *hst, SpecGPU info){
    int NO1 = 0;
    for(int i = 1; i < info.NUM_BLOCKS; i++){
        if(hst[i].L < hst[NO1].L){
            NO1 = i;
        }
    }
    return NO1;
}

void copy_input_sequences(DataMessanger *hst, InputSequences *InpSeq, SpecGPU info, int No){
    for(int i = 0; i < info.NUM_PRED_STEPS; i++){
        for(int k = 0; k < DIM_U; k++){
            InpSeq[k].u[i] = hst[No].u[k][i];
        }
    }
}

void TOP1_sample_method(DataMessanger *hst,SpecGPU gpu_info, InputSequences *InpSeq){
    int bestID;
    bestID = search_best_ID( hst, gpu_info);
    copy_input_sequences(hst, InpSeq, gpu_info, bestID);
}