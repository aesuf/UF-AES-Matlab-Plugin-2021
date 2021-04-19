/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * _coder_Convolver_api.c
 *
 * Code generation for function '_coder_Convolver_api'
 *
 */

/* Include files */
#include "_coder_Convolver_api.h"
#include "_coder_Convolver_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131594U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "Convolver",                         /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2045744189U, 2170104910U, 2743257031U, 4284093946U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

/* Function Declarations */
static int32_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *value,
  const char_T *identifier);
static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *i1, const
  char_T *identifier, real_T **y_data, int32_T y_size[1]);
static int32_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *paramIdx,
  const char_T *identifier);
static const mxArray *emlrt_marshallOut(const real_T u_data[], const int32_T
  u_size[1]);
static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T **y_data, int32_T y_size[1]);
static uint64_T g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *thisPtr,
  const char_T *identifier);
static uint64_T h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static int32_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId);
static real_T j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);
static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T **ret_data, int32_T ret_size[1]);
static uint64_T l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId);

/* Function Definitions */
static int32_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  int32_T y;
  y = i_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *value,
  const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(value), &thisId);
  emlrtDestroyArray(&value);
  return y;
}

static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = j_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *i1, const
  char_T *identifier, real_T **y_data, int32_T y_size[1])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  f_emlrt_marshallIn(sp, emlrtAlias(i1), &thisId, y_data, y_size);
  emlrtDestroyArray(&i1);
}

static int32_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *paramIdx,
  const char_T *identifier)
{
  int32_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(paramIdx), &thisId);
  emlrtDestroyArray(&paramIdx);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u_data[], const int32_T
  u_size[1])
{
  const mxArray *y;
  const mxArray *m;
  static const int32_T iv[1] = { 0 };

  y = NULL;
  m = emlrtCreateNumericArray(1, &iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u_data[0]);
  emlrtSetDimensions((mxArray *)m, *(int32_T (*)[1])&u_size[0], 1);
  emlrtAssign(&y, m);
  return y;
}

static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T **y_data, int32_T y_size[1])
{
  k_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y_data, y_size);
  emlrtDestroyArray(&u);
}

static uint64_T g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *thisPtr,
  const char_T *identifier)
{
  uint64_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = h_emlrt_marshallIn(sp, emlrtAlias(thisPtr), &thisId);
  emlrtDestroyArray(&thisPtr);
  return y;
}

static uint64_T h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  uint64_T y;
  y = l_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static int32_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId)
{
  int32_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "int32", false, 0U, &dims);
  ret = *(int32_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T **ret_data, int32_T ret_size[1])
{
  static const int32_T dims[1] = { 4096 };

  const boolean_T bv[1] = { true };

  int32_T iv[1];
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 1U, dims, &bv[0],
    iv);
  ret_size[0] = iv[0];
  *ret_data = (real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
}

static uint64_T l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId)
{
  uint64_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "uint64", false, 0U, &dims);
  ret = *(uint64_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void Convolver_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  Convolver_xil_terminate();
  Convolver_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void Convolver_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

void Convolver_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void createPluginInstance_api(const mxArray * const prhs[1], int32_T nlhs)
{
  uint64_T thisPtr;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  (void)nlhs;
  st.tls = emlrtRootTLSGlobal;

  /* Marshall function inputs */
  thisPtr = g_emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "thisPtr");

  /* Invoke the target function */
  createPluginInstance(thisPtr);
}

void onParamChangeCImpl_api(const mxArray * const prhs[2], int32_T nlhs)
{
  int32_T paramIdx;
  real_T value;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  (void)nlhs;
  st.tls = emlrtRootTLSGlobal;

  /* Marshall function inputs */
  paramIdx = emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "paramIdx");
  value = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "value");

  /* Invoke the target function */
  onParamChangeCImpl(paramIdx, value);
}

void processEntryPoint_api(const mxArray * const prhs[3], int32_T nlhs, const
  mxArray *plhs[2])
{
  real_T (*o1_data)[4096];
  real_T (*o2_data)[4096];
  real_T samplesPerFrame;
  real_T (*i1_data)[4096];
  int32_T i1_size[1];
  real_T (*i2_data)[4096];
  int32_T i2_size[1];
  int32_T o1_size[1];
  int32_T o2_size[1];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  o1_data = (real_T (*)[4096])mxMalloc(sizeof(real_T [4096]));
  o2_data = (real_T (*)[4096])mxMalloc(sizeof(real_T [4096]));

  /* Marshall function inputs */
  samplesPerFrame = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[0]),
    "samplesPerFrame");
  e_emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "i1", (real_T **)&i1_data,
                     i1_size);
  e_emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "i2", (real_T **)&i2_data,
                     i2_size);

  /* Invoke the target function */
  processEntryPoint(samplesPerFrame, *i1_data, i1_size, *i2_data, i2_size,
                    *o1_data, o1_size, *o2_data, o2_size);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*o1_data, o1_size);
  if (nlhs > 1) {
    plhs[1] = emlrt_marshallOut(*o2_data, o2_size);
  }
}

void resetCImpl_api(const mxArray * const prhs[1], int32_T nlhs)
{
  real_T rate;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  (void)nlhs;
  st.tls = emlrtRootTLSGlobal;

  /* Marshall function inputs */
  rate = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "rate");

  /* Invoke the target function */
  resetCImpl(rate);
}

/* End of code generation (_coder_Convolver_api.c) */
