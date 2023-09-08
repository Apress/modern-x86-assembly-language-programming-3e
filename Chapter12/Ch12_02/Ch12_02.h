//-----------------------------------------------------------------------------
// Ch12_02.h
//-----------------------------------------------------------------------------

#pragma once
#include "MatrixF64.h"

// Ch12_01_fasm.asm, Ch12_01_fasm.s
extern "C" bool Mat4x4InvF64_avx2(double* m_inv, const double* m, double epsilon);
extern "C" void Mat4x4MulF64_avx2(double* m_des, const double* m_src1,
    const double* m_src2);

// Ch12_01_fcpp.cpp
extern bool Mat4x4InvF64_cpp(MatrixF64& m_inv, const MatrixF64& m, double epsilon);

// Ch12_01_misc.cpp
extern void DisplayResults(MatrixF64& m_inv, MatrixF64& m_ver, bool rc,
    const char* msg, const char* fn, double epsilon);

// Ch12_01_bm.cpp
extern void Mat4x4InvF64_bm(void);

// Miscellaenous constants
constexpr int c_MatOstreamW = 14;           // MatrixF64 element ostream width
constexpr double c_Epsilon = 1.0e-9;        // epsilon for singular matrix test    

