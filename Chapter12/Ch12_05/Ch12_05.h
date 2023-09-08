//-----------------------------------------------------------------------------
// Ch12_05.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch12_05_fasm.asm, Ch12_05_fasm.s
extern "C" bool Convolve1D_Ks5_F32_avx2(float* y, const float* x,
    const float* kernel, int64_t num_pts);

// Ch12_05_fcpp.cpp
bool Convolve1D_Ks5_F32_cpp(float* y, const float* x, const float* kernel,
    int64_t num_pts);

// Ch12_05_bm.cpp
extern void Convolve1D_Ks5_F32_bm(void);

// Miscellaneous constants
constexpr unsigned int c_RngSeed = 97;
