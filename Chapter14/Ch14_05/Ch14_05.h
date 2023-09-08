//-----------------------------------------------------------------------------
// Ch14_05.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include "MatrixF32.h"

// Ch14_05_fasm.asm, Ch14_05_fasm.s
extern "C" void MatrixMulF32_avx512(float* c, const float* a, const float* b,
    const size_t * sizes);

// Ch14_05_fcpp.cpp
extern void MatrixMulF32_cpp(MatrixF32& c, const MatrixF32& a, const MatrixF32& b);

// Ch14_05_misc.cpp
extern bool CheckArgs(const MatrixF32& c, const MatrixF32& a, const MatrixF32& b);
extern void InitMat(MatrixF32& c1, MatrixF32& c2, MatrixF32& a, MatrixF32& b);
extern void SaveResults(const MatrixF32& c1, const MatrixF32& c2,
    const MatrixF32& a, const MatrixF32& b, const char* s = nullptr);

// Ch14_05_bm.cpp
extern void MatrixMulF32_bm(void);

// Miscellaneous constants
constexpr float c_Epsilon = 1.0e-9f;
