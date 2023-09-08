//-----------------------------------------------------------------------------
// Ch12_03.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch12_03_fasm.asm, Ch12_03_fasm.s
extern "C" bool Convolve1D_F32_avx2(float* y, const float* x, const float* kernel,
    int64_t num_pts, int64_t kernel_size);

// Ch12_03_fcpp.cpp
bool Convolve1D_F32_cpp(float* y, const float* x, const float* kernel,
    int64_t num_pts, int64_t kernel_size);

// Ch12_03_bm.cpp
extern void Convolve1D_F32_bm(void);

// Miscellaneous constants
constexpr unsigned int c_RngSeed = 97;
