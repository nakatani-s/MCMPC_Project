/*-- 
--*/
#include "../MCMPCtoolkit.cuh"
#include "DataStructures.cuh" 
#include "Messanger.cuh"
void TOP1_sample_method(DataMessanger *hst,SpecGPU gpu_info, InputSequences *InpSeq);
void copy_input_sequences(InputSequences *before, InputSequences *after, SpecGPU info);