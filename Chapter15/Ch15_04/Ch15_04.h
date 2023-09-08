//-----------------------------------------------------------------------------
// Ch15_04.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch15_04_fasm.asm, Ch15_04_fasm.s
extern "C" bool Convolve1D_Ks5_F64_avx512(double* y, const double* x,
    const double* kernel, int64_t num_pts);

// Ch15_04_fcpp.cpp
bool Convolve1D_Ks5_F64_cpp(double* y, const double* x, const double* kernel,
    int64_t num_pts);

// Ch15_04_bm.cpp
extern void Convolve1D_Ks5_F64_bm(void);

// Miscellaneous constants
constexpr unsigned int c_RngSeed = 97;
