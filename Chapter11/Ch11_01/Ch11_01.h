//-----------------------------------------------------------------------------
// Ch11_01.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>

// Ch11_01_fasm.asm, Ch11_01_fasm.s
extern "C" void CalcLeastSquares_avx2(double* m, double* b, const double* x,
    const double* y, size_t n, double epsilon);

// Ch11_01_fcpp.cpp
extern void CalcLeastSquares_cpp(double* m, double* b, const double* x,
    const double* y, size_t n, double epsilon);

// Ch11_01_misc.cpp
extern void InitArrays(double* x, double* y, size_t n);

// Ch11_02_bm.cpp
extern void CalcLeastSquares_bm(void);

// Miscellaneous constants
constexpr size_t c_Alignment = 32;
constexpr double c_LsEpsilon = 1.0e-12;
constexpr unsigned int c_RngSeed1 = 73;
constexpr unsigned int c_RngSeed2 = 83;
constexpr double c_RngMinVal = -25.0;
constexpr double c_RngMaxVal = 25.0;
