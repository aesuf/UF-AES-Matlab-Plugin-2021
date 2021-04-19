/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * _coder_Convolver_mex.c
 *
 * Code generation for function '_coder_Convolver_mex'
 *
 */

/* Include files */
#include "_coder_Convolver_mex.h"
#include "_coder_Convolver_api.h"

/* Variable Definitions */
static const char * emlrtEntryPoints[4] = { "onParamChangeCImpl", "resetCImpl",
  "processEntryPoint", "createPluginInstance" };

/* Function Declarations */
MEXFUNCTION_LINKAGE void c_createPluginInstance_mexFunct(int32_T nlhs, int32_T
  nrhs, const mxArray *prhs[1]);
MEXFUNCTION_LINKAGE void onParamChangeCImpl_mexFunction(int32_T nlhs, int32_T
  nrhs, const mxArray *prhs[2]);
MEXFUNCTION_LINKAGE void processEntryPoint_mexFunction(int32_T nlhs, mxArray
  *plhs[2], int32_T nrhs, const mxArray *prhs[3]);
MEXFUNCTION_LINKAGE void resetCImpl_mexFunction(int32_T nlhs, int32_T nrhs,
  const mxArray *prhs[1]);

/* Function Definitions */
void c_createPluginInstance_mexFunct(int32_T nlhs, int32_T nrhs, const mxArray
  *prhs[1])
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 1, 4,
                        20, "createPluginInstance");
  }

  if (nlhs > 0) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 20,
                        "createPluginInstance");
  }

  /* Call the function. */
  createPluginInstance_api(prhs, nlhs);
}

void onParamChangeCImpl_mexFunction(int32_T nlhs, int32_T nrhs, const mxArray
  *prhs[2])
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 2, 4,
                        18, "onParamChangeCImpl");
  }

  if (nlhs > 0) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 18,
                        "onParamChangeCImpl");
  }

  /* Call the function. */
  onParamChangeCImpl_api(prhs, nlhs);
}

void processEntryPoint_mexFunction(int32_T nlhs, mxArray *plhs[2], int32_T nrhs,
  const mxArray *prhs[3])
{
  const mxArray *outputs[2];
  int32_T b_nlhs;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 3, 4,
                        17, "processEntryPoint");
  }

  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 17,
                        "processEntryPoint");
  }

  /* Call the function. */
  processEntryPoint_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);
}

void resetCImpl_mexFunction(int32_T nlhs, int32_T nrhs, const mxArray *prhs[1])
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 1, 4,
                        10, "resetCImpl");
  }

  if (nlhs > 0) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 10,
                        "resetCImpl");
  }

  /* Call the function. */
  resetCImpl_api(prhs, nlhs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexAtExit(&Convolver_atexit);

  /* Module initialization. */
  Convolver_initialize();
  st.tls = emlrtRootTLSGlobal;

  /* Dispatch the entry-point. */
  switch (emlrtGetEntryPointIndexR2016a(&st, nrhs, prhs, emlrtEntryPoints, 4)) {
   case 0:
    onParamChangeCImpl_mexFunction(nlhs, nrhs - 1, *(const mxArray *(*)[2])&
      prhs[1]);
    break;

   case 1:
    resetCImpl_mexFunction(nlhs, nrhs - 1, *(const mxArray *(*)[1])&prhs[1]);
    break;

   case 2:
    processEntryPoint_mexFunction(nlhs, plhs, nrhs - 1, *(const mxArray *(*)[3])
      &prhs[1]);
    break;

   case 3:
    c_createPluginInstance_mexFunct(nlhs, nrhs - 1, *(const mxArray *(*)[1])&
      prhs[1]);
    break;
  }

  /* Module termination. */
  Convolver_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_Convolver_mex.c) */
