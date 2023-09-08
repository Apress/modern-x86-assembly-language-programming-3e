//-----------------------------------------------------------------------------
// Ch11_03.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include "MatrixF64.h"

// Ch11_03_fasm.asm, Ch11_03_fasm.s
extern "C" void MatrixMulF64_avx2(double* c, const double* a, const double* b,
    const size_t * sizes);

// Ch11_03_fcpp.cpp
extern void MatrixMulF64_cpp(MatrixF64& c, const MatrixF64& a, const MatrixF64& b);

// Ch11_03_misc.cpp
extern void InitMat(MatrixF64& c1, MatrixF64& c2, MatrixF64& a, MatrixF64& b);
extern void SaveResults(const MatrixF64& c1, const MatrixF64& c2,
    const MatrixF64& a, const MatrixF64& b, const char* s = nullptr);

// Ch11_03_bm.cpp
extern void MatrixMulF64_bm(void);

// Ch11_03_test.cpp  (test code using intrinsics)
extern void MatrixMulF64_test(MatrixF64& c, const MatrixF64& a,
    const MatrixF64& b);

// Miscellaneous constants
constexpr double c_Epsilon = 1.0e-9f;
