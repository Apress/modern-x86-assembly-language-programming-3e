//-----------------------------------------------------------------------------
// Ch11_04.h
//-----------------------------------------------------------------------------

#pragma once
#include "MatrixF32.h"

// Ch11_04_fasm.asm, Ch11_04_fasm.s
extern "C" void MatrixMul4x4F32a_avx2(float* c, const float* a, const float* b);
extern "C" void MatrixMul4x4F32b_avx2(float* c, const float* a, const float* b);

// Ch11_04_fcpp.cpp
extern void MatrixMul4x4F32_cpp(MatrixF32& c, const MatrixF32& a,
    const MatrixF32& b);

// Ch11_04_misc.cpp
extern void InitMat(MatrixF32& c1, MatrixF32& c2, MatrixF32& c3, MatrixF32& a,
    MatrixF32& b);

// Ch11_04_bm.cpp
extern void MatrixMul4x4F32_bm(void);

// Miscellaneous constants
constexpr float c_Epsilon = 1.0e-9f;
