/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * _coder_Convolver_api.h
 *
 * Code generation for function '_coder_Convolver_api'
 *
 */

#ifndef _CODER_CONVOLVER_API_H
#define _CODER_CONVOLVER_API_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void Convolver_atexit(void);
extern void Convolver_initialize(void);
extern void Convolver_terminate(void);
extern void Convolver_xil_shutdown(void);
extern void Convolver_xil_terminate(void);
extern void createPluginInstance(uint64_T thisPtr);
extern void createPluginInstance_api(const mxArray * const prhs[1], int32_T nlhs);
extern void onParamChangeCImpl(int32_T paramIdx, real_T value);
extern void onParamChangeCImpl_api(const mxArray * const prhs[2], int32_T nlhs);
extern void processEntryPoint(real_T samplesPerFrame, real_T i1_data[], int32_T
  i1_size[1], real_T i2_data[], int32_T i2_size[1], real_T o1_data[], int32_T
  o1_size[1], real_T o2_data[], int32_T o2_size[1]);
extern void processEntryPoint_api(const mxArray * const prhs[3], int32_T nlhs,
  const mxArray *plhs[2]);
extern void resetCImpl(real_T rate);
extern void resetCImpl_api(const mxArray * const prhs[1], int32_T nlhs);

#endif

/* End of code generation (_coder_Convolver_api.h) */
