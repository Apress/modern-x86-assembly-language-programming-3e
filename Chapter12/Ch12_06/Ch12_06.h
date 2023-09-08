//-----------------------------------------------------------------------------
// Ch12_06.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch12_06_fasm.asm, Ch12_06_fasm.s
extern "C" bool Convolve1D_Ks5_F64_avx2(double* y, const double* x,
    const double* kernel, int64_t num_pts);

// Ch12_06_fcpp.cpp
bool Convolve1D_Ks5_F64_cpp(double* y, const double* x, const double* kernel,
    int64_t num_pts);

// Ch12_06_bm.cpp
extern void Convolve1D_Ks5_F64_bm(void);

// Miscellaneous constants
constexpr unsigned int c_RngSeed = 97;
