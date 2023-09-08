//-----------------------------------------------------------------------------
// Ch11_02.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include "MatrixF32.h"

// Ch11_02_fasm.asm, Ch11_02_fasm.s
extern "C" void MatrixMulF32_avx2(float* c, const float* a, const float* b,
    const size_t* sizes);

// Ch11_02_fcpp.cpp
extern void MatrixMulF32_cpp(MatrixF32& c, const MatrixF32& a, const MatrixF32& b);

// Ch11_02_misc.cpp
extern void InitMat(MatrixF32& c1, MatrixF32& c2, MatrixF32& a, MatrixF32& b);
extern void SaveResults(const MatrixF32& c1, const MatrixF32& c2,
    const MatrixF32& a, const MatrixF32& b, const char* s = nullptr);

// Ch11_02_bm.cpp
extern void MatrixMulF32_bm(void);

// Ch11_02_test.cpp (test code using intrinsics)
extern void MatrixMulF32_test(MatrixF32& c, const MatrixF32& a,
    const MatrixF32& b);

// Miscellaneous constants
constexpr float c_Epsilon = 1.0e-9f;
