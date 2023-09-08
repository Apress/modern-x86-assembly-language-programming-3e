//-----------------------------------------------------------------------------
// Ch11_07.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include "MatrixF64.h"

// Simple 4x1 vector structure
struct Vec4x1_F64
{
    double W, X, Y, Z;
};

// Ch11_07_fasm.asm, Ch11_07_fasm.s
extern "C" void MatVecMulF64_avx2(Vec4x1_F64 * vec_b, const double* m,
    const Vec4x1_F64 * vec_a, size_t num_vec);

// Ch11_07_fcpp.cpp
extern void MatVecMulF64_cpp(Vec4x1_F64* vec_b, const MatrixF64& m,
    const Vec4x1_F64* vec_a, size_t num_vec);

// Ch11_07_misc.cpp
extern "C" bool CheckArgs(const Vec4x1_F64 * vec_b, const MatrixF64 & m,
    const Vec4x1_F64 * vec_a, size_t num_vec);
extern void InitData(MatrixF64& m, Vec4x1_F64* va, size_t num_vec);
extern bool VecCompare(const Vec4x1_F64* v1, const Vec4x1_F64* v2);

// Ch11_07_bm.cpp
extern void MatrixVecMulF64_bm(void);

// Miscellaenous constants
constexpr size_t c_Alignment = 32;
constexpr int c_RngMinVal = 1;
constexpr int c_RngMaxVal = 500;
constexpr unsigned int c_RngSeedVal = 187;
constexpr double c_Epsilon = 1.0e-12f;

