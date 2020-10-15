/*-- 
--*/
// #include "MCMPC_all_Header.cuh"
#include "../MCMPCtoolkit.cuh"
#include "Messanger.cuh"
__device__ void general_copy(float *af, float *be, int dims);
__device__ float input_saturation(float in, float *constraint, int k);

void copy_current_input(float *Input, InputSequences *inp_from_host);
void Shift_Input_Sequences(InputSequences *inp_from_host);