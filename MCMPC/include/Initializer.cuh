/*-- 
--*/
#include "../MCMPCtoolkit.cuh"
#include "DataStructures.cuh"
#include "Messanger.cuh"

/*ControllerInfo _controller;
SpecGPU get_info;
ControllerParams get_param;
DataMessanger *host_, *device_;
InputSequences *Input_Seq;*/

#ifndef INITIALIZER_CUH
#define INITIALIZER_CUH

void Initialize(float *state, float *input, float *diff_st, SpecGPU &a, ControllerParams &get_param, DataMessanger *hst, InputSequences *inp_sq);

#endif