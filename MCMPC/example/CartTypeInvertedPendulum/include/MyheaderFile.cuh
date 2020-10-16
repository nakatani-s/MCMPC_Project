/*--
--*/
#include <math.h>
#ifndef MYHEADERFILE_CUH
#define MYHEADERFILE_CUH

#define DIM_X 4
#define DIM_U 1

const int NUM_OF_BLOCKS     = 50;
//#define NUM_OF_BLOCKS 100
const int NUM_OF_THREAD_PER_BLOCKS = 50;
const int NUM_OF_HORIZON           = 100;
const int NUM_OF_ITERATIONS        = 10;

const float CONTROL_CYCLE = 0.01;
const float INITIAL_SIGMA[DIM_U] = { 1.2f };
const float Clambda  = 100; // We recommend a constant multiple of horizon

#define PREDICTIVE_METHOD 1 // <-----choose 1 or 2 as Predictive method (1 -> TOP1_sample, 2 -> Elite sample )
#define COOLING_PATTERN 1 //<---- choose cooling pattern ( 1-> geometric_cooling, 2 -> hyperbolic_cooling )
const float RATE_OF_COOLING[DIM_U] = { 0.95f };


#define NUM_OF_SYS_PARAMETERS 7
const float m_c   = 0.1f; // Mass of Cart 
const float m_p   = 0.01f; // Mass of pendulum
const float l_p   = 0.20f; // Length of pendulum
const float J     = 0.00032f; // Moment of inatia
const float myu_c = 1.265;  //
const float myu_p = 0.0000001; //
const float g     = 9.8; ///
const float system_params[NUM_OF_SYS_PARAMETERS] = {m_c, m_p, l_p, J, myu_c, myu_p, g};

#define WITH_TERMINAL_COST 1 //Choose 1 or 2 (1 >> without terminal cost  2>> with teminal cost)
#define DIM_Q 4
#define DIM_R 1
#define DIM_Qf 4
#define DIM_Rf 1

const float Q[DIM_Q] = {1.75, 1.75, 0.04, 0.05};
const float R[DIM_R] = { 1 };
const float Qf[DIM_Qf] = { };
const float Rf[DIM_Rf] = { };

const float initial_state[DIM_X] = {0.0f, M_PI, 0.0f, 0.0f};
const float initial_input[DIM_U] = { 0.0f };
const float initial_diff_state[DIM_X] = {0.0f, 0.0f, 0.0f, 0.0f};

#define CONSTRAINT_TYPE 1 //choose 1 or 2 or ... (1 >> invers_barrier, 2 >> log_barrier, otherwise >> well_type)
#define NUM_OF_I_CONSTRAINT 2
#define NUM_OF_S_CONSTRAINT 2

const float constraint_for_input[NUM_OF_I_CONSTRAINT] = {-1.0f, 1.0f};
const float constraint_for_state[NUM_OF_S_CONSTRAINT] = {-0.5f, 0.5f};

#endif