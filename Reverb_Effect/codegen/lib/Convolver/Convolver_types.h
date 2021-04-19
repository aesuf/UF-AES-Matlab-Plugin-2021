//
//  Student License - for use by students to meet course requirements and
//  perform academic research at degree granting institutions only.  Not
//  for government, commercial, or other organizational use.
//
//  Convolver_types.h
//
//  Code generation for function 'Convolver_types'
//


#ifndef CONVOLVER_TYPES_H
#define CONVOLVER_TYPES_H

// Include files
#include "rtwtypes.h"
#include "coder_array.h"
#ifdef _MSC_VER

#pragma warning(push)
#pragma warning(disable : 4251)

#endif

// Type Declarations
struct cell_wrap_2;
class dsp_private_AsyncBuffercgHelper;
class dsp_private_AsyncBuffercg;
class dsp_private_PartitionOS;
class dsp_FrequencyDomainFIRFilter;
class derivedAudioPlugin;
struct ConvolverPersistentData;
struct ConvolverStackData;

// Type Definitions
struct cell_wrap_2
{
  unsigned int f1[8];
};

class dsp_private_AsyncBuffercgHelper
{
 public:
  dsp_private_AsyncBuffercgHelper *init();
  void setup();
  void reset();
  int step(const double varargin_1[191976]);
  void setupAndReset();
  int write(const double in[191976]);
  int get_NumUnreadSamples() const;
  void read(int numRows, coder::array<double, 1U> &out, int *underrun);
  static void ReadSamplesFromBuffer(const dsp_private_AsyncBuffercgHelper *obj,
    int numRowsCast, coder::array<double, 1U> &out, int *underrun, int *c);
  int step(const coder::array<double, 1U> &varargin_1);
  void setupAndReset(const coder::array<double, 1U> &varargin_1);
  void setup(const coder::array<double, 1U> &varargin_1);
  int write(const coder::array<double, 1U> &in);
  void matlabCodegenDestructor();
  void release();
  void releaseWrapper();
  ~dsp_private_AsyncBuffercgHelper();
  boolean_T matlabCodegenIsDeleted;
  double Cache[191977];
  int ReadPointer;
  int WritePointer;
  boolean_T c_AsyncBuffercgHelper_isInitial;
 protected:
  int isInitialized;
  int CumulativeOverrun;
  int CumulativeUnderrun;
 private:
  boolean_T isSetupComplete;
  cell_wrap_2 inputVarSize[1];
  int NumChannels;
};

class dsp_private_AsyncBuffercg
{
 public:
  dsp_private_AsyncBuffercg *init();
  void setup();
  void reset();
  void step(const double in[191976]);
  int write(const double in[191976]);
  int get_NumUnreadSamples() const;
  void read(int numRows, coder::array<double, 1U> &out);
  void write(const coder::array<double, 1U> &in);
  void matlabCodegenDestructor();
  ~dsp_private_AsyncBuffercg();
  boolean_T matlabCodegenIsDeleted;
  dsp_private_AsyncBuffercgHelper pBuffer;
};

class dsp_private_PartitionOS
{
 public:
  dsp_private_PartitionOS *init(const double varargin_4[191976]);
  boolean_T isLockedAndNotReleased() const;
  void setup(ConvolverStackData *SD);
  void reset(ConvolverStackData *SD);
  void step(ConvolverStackData *SD, const double varargin_1_data[], const int
            varargin_1_size[1], double varargout_1_data[], int varargout_1_size
            [1]);
  void setupAndReset(ConvolverStackData *SD);
  void checkTunableProps(ConvolverStackData *SD);
  void matlabCodegenDestructor();
  void release();
  static void computeOutput(ConvolverStackData *SD, const coder::array<double,
    1U> &input, creal_T sumY[383952], double *p, const creal_T H[383952], double
    prevsec[191976], coder::array<double, 1U> &o);
  ~dsp_private_PartitionOS();
 protected:
  void setupImpl(ConvolverStackData *SD);
  void stepImpl(ConvolverStackData *SD, const double u_data[], const int u_size
                [1], double y_data[], int y_size[1]);
 public:
  boolean_T matlabCodegenIsDeleted;
  boolean_T TunablePropsChanged;
  double Numerator[191976];
  dsp_private_AsyncBuffercg pinBuff;
  dsp_private_AsyncBuffercg poutBuff;
 protected:
  double pSumIdx;
  creal_T pSum[383952];
  double pLastSection[191976];
  creal_T pIRFFT[383952];
 private:
  int isInitialized;
  boolean_T isSetupComplete;
};

class dsp_FrequencyDomainFIRFilter
{
 public:
  boolean_T isLockedAndNotReleased() const;
  dsp_FrequencyDomainFIRFilter *init(const double varargin_2[191976]);
  void set_Numerator(const double value[191976]);
  void step(ConvolverStackData *SD, const double varargin_1_data[], const int
            varargin_1_size[1], double varargout_1_data[], int varargout_1_size
            [1]);
  void setupAndReset(ConvolverStackData *SD, const int varargin_1_size[1]);
  void setup(ConvolverStackData *SD, const int varargin_1_size[1]);
  void checkTunableProps();
  void matlabCodegenDestructor();
  void release();
  void releaseWrapper();
  ~dsp_FrequencyDomainFIRFilter();
 protected:
  void setupImpl(ConvolverStackData *SD);
 public:
  boolean_T matlabCodegenIsDeleted;
  boolean_T TunablePropsChanged;
  double Numerator[191976];
  dsp_private_PartitionOS pFilter;
 private:
  int isInitialized;
  boolean_T isSetupComplete;
  cell_wrap_2 inputVarSize[1];
  int NumChannels;
};

class derivedAudioPlugin
{
 public:
  derivedAudioPlugin *init(ConvolverStackData *SD);
  void process(ConvolverStackData *SD, const coder::array<double, 2U> &out,
               coder::array<double, 2U> &y);
  void matlabCodegenDestructor();
  ~derivedAudioPlugin();
  boolean_T matlabCodegenIsDeleted;
  dsp_FrequencyDomainFIRFilter pFIR_L;
  dsp_FrequencyDomainFIRFilter pFIR_R;
};

struct ConvolverPersistentData
{
  derivedAudioPlugin plugin;
  boolean_T plugin_not_empty;
  unsigned long long thisPtr;
  boolean_T thisPtr_not_empty;
};

struct ConvolverStackData
{
  struct {
    double costab1q[262145];
  } f0;

  struct {
    double costab1q[191977];
  } f1;

  struct {
    double dv[191976];
  } f2;

  struct {
    creal_T fv[1048576];
    creal_T b_fv[1048576];
    creal_T wwc[767903];
    double costab[524289];
    double sintab[524289];
    double sintabinv[524289];
  } f3;

  struct {
    creal_T fv[524288];
    creal_T b_fv[524288];
    double costable[383953];
    double sintable[383953];
    double unusedU0[383953];
    creal_T ytmp[191976];
    creal_T reconVar1[191976];
    creal_T reconVar2[191976];
    double hcostab[262144];
    double hsintab[262144];
    double hcostabinv[262144];
    double hsintabinv[262144];
    int wrapIndex[191976];
  } f4;

  struct {
    creal_T fv[524288];
    creal_T b_fv[524288];
    double costable[383953];
    double sintable[383953];
    double unusedU0[383953];
    creal_T reconVar1[191976];
    creal_T reconVar2[191976];
    creal_T ytmp[191976];
    double hcostab[262144];
    double hsintab[262144];
    double hcostabinv[262144];
    double hsintabinv[262144];
    int wrapIndex[191976];
  } f5;

  struct {
    creal_T wwc[383951];
    double costab[524289];
    double sintab[524289];
    double sintabinv[524289];
  } f6;

  struct {
    creal_T wwc[383951];
    double costab[524289];
    double sintab[524289];
    double sintabinv[524289];
  } f7;

  struct {
    creal_T c[383952];
  } f8;

  struct {
    double h[191976];
  } f9;

  struct {
    creal_T H[383952];
    creal_T sumY[383952];
    double prevsec[191976];
  } f10;

  struct {
    double dv[191976];
  } f11;

  struct {
    double num[191976];
  } f12;

  ConvolverPersistentData *pd;
};

#ifdef _MSC_VER

#pragma warning(pop)

#endif
#endif

// End of code generation (Convolver_types.h)
