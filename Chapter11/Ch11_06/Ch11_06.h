//-----------------------------------------------------------------------------
// Ch11_06.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include "MatrixF32.h"

// Simple 4x1 vector structure
struct Vec4x1_F32
{
    float W, X, Y, Z;
};

// Ch11_06_fasm.asm, Ch11_06_fasm.s
extern "C" void MatVecMulF32_avx2(Vec4x1_F32* vec_b, const float* m,
    const Vec4x1_F32* vec_a, size_t num_vec);

// Ch11_06_fcpp.cpp
extern void MatVecMulF32_cpp(Vec4x1_F32* vec_b, const MatrixF32& m,
    const Vec4x1_F32* vec_a, size_t num_vec);

// Ch11_06_misc.cpp
extern void InitData(MatrixF32& m, Vec4x1_F32* va, size_t num_vec);
extern bool VecCompare(const Vec4x1_F32* v1, const Vec4x1_F32* v2);

// Ch11_06_bm.cpp
extern void MatrixVecMulF32_bm(void);

// Miscellaenous constants
constexpr size_t c_Alignment = 32;
constexpr int c_RngMinVal = 1;
constexpr int c_RngMaxVal = 500;
constexpr unsigned int c_RngSeedVal = 187;
constexpr float c_Epsilon = 1.0e-12f;
