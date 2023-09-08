//-----------------------------------------------------------------------------
// Ch15_02.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch15_02_fasm.asm, Ch15_02_fasm.s
extern "C" bool Convolve1D_F64_avx512(double* y, const double* x, const double* kernel,
    int64_t num_pts, int64_t kernel_size);

// Ch15_02_fcpp.cpp
bool Convolve1D_F64_cpp(double* y, const double* x, const double* kernel,
    int64_t num_pts, int64_t kernel_size);

// Ch15_02_bm.cpp
extern void Convolve1D_F64_bm(void);

// Miscellaneous constants
constexpr unsigned int c_RngSeed = 97;
