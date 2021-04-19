//
//  Student License - for use by students to meet course requirements and
//  perform academic research at degree granting institutions only.  Not
//  for government, commercial, or other organizational use.
//
//  Convolver.h
//
//  Code generation for function 'Convolver'
//


#ifndef CONVOLVER_H
#define CONVOLVER_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "Convolver_types.h"

// Function Declarations
extern void Convolver_initialize(ConvolverStackData *SD);
extern void Convolver_terminate(ConvolverStackData *SD);
extern void createPluginInstance(ConvolverStackData *SD, unsigned long long
  thisPtr);
extern void onParamChangeCImpl(ConvolverStackData *SD, int paramIdx, double
  value);
extern void processEntryPoint(ConvolverStackData *SD, double samplesPerFrame,
  const double i1_data[], const int i1_size[1], const double i2_data[], const
  int i2_size[1], double o1_data[], int o1_size[1], double o2_data[], int
  o2_size[1]);
extern void resetCImpl(ConvolverStackData *SD, double rate);

#endif

// End of code generation (Convolver.h)
