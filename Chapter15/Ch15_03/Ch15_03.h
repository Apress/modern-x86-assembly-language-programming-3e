//-----------------------------------------------------------------------------
// Ch15_03.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch15_03_fasm.asm, Ch15_03_fasm.s
extern "C" bool Convolve1D_Ks5_F32_avx512(float* y, const float* x,
    const float* kernel, int64_t num_pts);

// Ch15_03_fcpp.cpp
bool Convolve1D_Ks5_F32_cpp(float* y, const float* x, const float* kernel,
    int64_t num_pts);

// Ch15_03_bm.cpp
extern void Convolve1D_Ks5_F32_bm(void);

// Miscellaneous constants
constexpr unsigned int c_RngSeed = 97;

