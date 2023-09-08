//-----------------------------------------------------------------------------
// Ch11_05.h
//-----------------------------------------------------------------------------

#pragma once
#include "MatrixF64.h"

// Ch11_05_fasm.asm, Ch11_05_fasm.s
extern "C" void MatrixMul4x4F64a_avx2(double* c, const double* a, const double* b);
extern "C" void MatrixMul4x4F64b_avx2(double* c, const double* a, const double* b);

// Ch11_05_fcpp.cpp
extern void MatrixMul4x4F64_cpp(MatrixF64& c, const MatrixF64& a,
    const MatrixF64& b);

// Ch11_05_misc.cpp
extern void InitMat(MatrixF64& c1, MatrixF64& c2, MatrixF64& c3, MatrixF64& a,
    MatrixF64& b);

// Ch11_05_bm.cpp
extern void MatrixMul4x4F64_bm(void);

// Miscellaneous constants
constexpr double c_Epsilon = 1.0e-9;
