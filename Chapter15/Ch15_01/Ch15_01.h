//-----------------------------------------------------------------------------
// Ch15_01.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch15_01_fasm.asm, Ch15_01_fasm.s
extern "C" bool Convolve1D_F32_avx512(float* y, const float* x, const float* kernel,
    int64_t num_pts, int64_t kernel_size);

// Ch15_01_fcpp.cpp
bool Convolve1D_F32_cpp(float* y, const float* x, const float* kernel,
    int64_t num_pts, int64_t kernel_size);

// Ch15_01_bm.cpp
extern void Convolve1D_F32_bm(void);

// Miscellaneous constants
constexpr unsigned int c_RngSeed = 97;

