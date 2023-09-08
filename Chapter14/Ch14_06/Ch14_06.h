//-----------------------------------------------------------------------------
// Ch14_06.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include "MatrixF64.h"

// Ch14_06_fasm.asm, Ch14_06_fasm.s
extern "C" void MatrixMulF64_avx512(double* c, const double* a, const double* b,
    const size_t* sizes);

// Ch14_06_fcpp.cpp
extern void MatrixMulF64_cpp(MatrixF64& c, const MatrixF64& a, const MatrixF64& b);

// Ch14_06_misc.cpp
extern bool CheckArgs(const MatrixF64& c, const MatrixF64& a, const MatrixF64& b);
extern void InitMat(MatrixF64& c1, MatrixF64& c2, MatrixF64& a, MatrixF64& b);
extern void SaveResults(const MatrixF64& c1, const MatrixF64& c2,
    const MatrixF64& a, const MatrixF64& b, const char* s = nullptr);

// Ch14_06_bm.cpp
extern void MatrixMulF64_bm(void);

// Miscellaneous constants
constexpr double c_Epsilon = 1.0e-9f;
