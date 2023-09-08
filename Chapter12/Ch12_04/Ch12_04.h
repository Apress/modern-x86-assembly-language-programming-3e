//-----------------------------------------------------------------------------
// Ch12_04.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch12_04_fasm.asm, Ch12_04_fasm.s
extern "C" bool Convolve1D_F64_avx2(double* y, const double* x, const double* kernel,
    int64_t num_pts, int64_t kernel_size);

// Ch12_04_fcpp.cpp
bool Convolve1D_F64_cpp(double* y, const double* x, const double* kernel,
    int64_t num_pts, int64_t kernel_size);

// Ch12_04_bm.cpp
extern void Convolve1D_F64_bm(void);

// Miscellaneous constants
constexpr unsigned int c_RngSeed = 97;

