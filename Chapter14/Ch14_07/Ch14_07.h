//-----------------------------------------------------------------------------
// Ch14_07.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include "MatrixF32.h"

// Simple 4x1 vector structure
struct Vec4x1_F32
{
    float W, X, Y, Z;
};

// Ch14_07_fasm.asm, Ch14_07_fasm.s
extern "C" void MatVecMulF32_avx512(Vec4x1_F32* vec_b, const float* m,
    const Vec4x1_F32* vec_a, size_t num_vec);

// Ch14_07_fcpp.cpp
extern void MatVecMulF32_cpp(Vec4x1_F32* vec_b, const MatrixF32& m,
    const Vec4x1_F32* vec_a, size_t num_vec);

// Ch14_07_misc.cpp
extern "C" bool CheckArgs(const Vec4x1_F32* vec_b, const MatrixF32 & m,
    const Vec4x1_F32* vec_a, size_t num_vec);
extern void InitData(MatrixF32& m, Vec4x1_F32* va, size_t num_vec);
extern bool VecCompare(const Vec4x1_F32* v1, const Vec4x1_F32* v2);

// Ch16_04_bm.cpp
extern void MatrixVecMulF32_bm(void);

// Miscellaenous constants
constexpr size_t c_Alignment = 64;
constexpr int c_RngMinVal = 1;
constexpr int c_RngMaxVal = 500;
constexpr unsigned int c_RngSeedVal = 187;
constexpr float c_Epsilon = 1.0e-12f;
