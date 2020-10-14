/*-- 
--*/
#include "../../../include/MyFunctions.cuh"

__host__ __device__ float calc_ddx(float *state, float *input, float *param) {
    float a[10];
    /*-- state[DIM_X] = {x, theta, dx, dtheta} --*/ 
    /*-- input[DIM_U] = { u } --*/
    /*-- param[NUM_OF_SYS_PARAMETERS] = {m_c, m_p, l_p, J, myu_c, myu_p, g}--*/ 
    a[0] = param[3] + powf(param[2], 2) * param[1];		//J+l^2*mp
    a[1] = input[0] - state[2] * param[4] + powf(state[3], 2) * param[2] * param[1] * sinf(state[1]);//u-dx*myuc+dtheta^2*l*mp*sin
    a[2] = cosf(state[1]) * param[2] * param[1];						//cos*l*mp
    a[3] = state[3] * param[5] - param[6] * param[2] * param[1] * sinf(state[1]);//dtheta*myup-g*l*mp*sin
    a[4] = -(a[0] * a[1] + a[2] * a[3]);

    a[5] = powf(cosf(state[1]), 2) * powf(param[2], 2) * powf(param[1], 2);//cos^2 * l_p^2 * m_p^2
    a[6] = param[0] + param[1];		//m_c + m_p
    a[7] = param[3] + powf(param[2], 2) * param[1];		//J+l^2*m_p
    a[8] = a[5] - (a[6] * a[7]);

    return a[4] / a[8]; //current ddx
}

__host__ __device__ float calc_ddtheta(float *state, float *input, float *param) {
    float a[10];
    /*-- state[DIM_X] = {x, theta, dx, dtheta} --*/ 
    /*-- input[DIM_U] = { u } --*/
    /*-- param[NUM_OF_SYS_PARAMETERS] = {m_c, m_p, l_p, J, myu_c, myu_p, g}--*/ 
    a[0] = cosf(state[1]) * param[2] * param[1];		//cos*l*mp
    a[1] = input[0] - state[2] * param[4] + powf(state[1], 2) * param[2] * param[1] * sinf(state[1]);//u-dx*myuc+dtheta^2*l*mp*sin
    a[2] = param[0] + param[1];		//mc+mp
    a[3] = state[3] * param[5] - param[6] * param[2] * param[1] * sinf(state[1]);//dtheta*myup-g*l*mp*sin
    a[4] = -(a[0] * a[1] + a[2] * a[3]);

    a[5] = param[3] * (param[0] + param[1]);		//J(mc+mp)
    a[6] = powf(param[2], 2) * param[1];		//l^2*mp
    a[7] = param[0] + param[1] - powf(cosf(state[1]), 2) * param[1];//mc+mp-cos^2*mp
    a[8] = a[5] + a[6] * a[7];
    return a[4] / a[8];  // current ddtheta
}


/*-- The following formulas are the minimum required --*/ 
__host__ __device__ void get_current_diff_state(float *state, float *input, float *param, float *diff_state){
    /*-- p_state[DIM_X] = {dx, dtheta, ddx, ddtheta}--*/
    /*-- state[DIM_X] = {x, theta, dx, dtheta} --*/ 
    /*-- input[DIM_U] = { u } --*/
    /*-- param[NUM_OF_SYS_PARAMETERS] = {m_c, m_p, l_p, J, myu_c, myu_p, g}--*/
    diff_state[0] = state[2];
    diff_state[1] = state[3];
    diff_state[2] = calc_ddx(state, input, param);
    diff_state[3] = calc_ddtheta(state, input, param);
}

__host__ __device__ float get_stage_cost(float *state, float *diff_state, float *input, float *q, float *r, float *state_constraint){

    float re = 0;
    float theta = state[1];
    while (theta > M_PI)
        theta -= (2 * M_PI);
    while (theta < -M_PI)
        theta += (2 * M_PI);
     
    // re = x*Q11*x + 
    re += state[0] * state[0] * q[0]; // x * x * Q11
    re += theta * theta * q[1];       // th * th * Q22
    re += state[2] * state[2] * q[2]; // dx * dx * Q33
    re += state[3] * state[3] * q[3]; // dth * dth * Q44
    re += input[0] * input[0] * r[0]; // u * u * R

    re += state_constraint_barrier(state[0], state_constraint[0], state_constraint[1], 1);
    // state_constraint_barrier1(state);
    return re;

}