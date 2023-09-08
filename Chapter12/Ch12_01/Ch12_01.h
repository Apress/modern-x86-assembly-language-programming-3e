//-----------------------------------------------------------------------------
// Ch12_01.h
//-----------------------------------------------------------------------------

#pragma once
#include "MatrixF32.h"

// Ch12_01_fasm.asm, Ch12_01_fasm.s
extern "C" bool Mat4x4InvF32_avx2(float* m_inv, const float* m, float epsilon);
extern "C" void Mat4x4MulF32_avx2(float* m_des, const float* m_src1,
    const float* m_src2);

// Ch12_01_fcpp.cpp
extern bool Mat4x4InvF32_cpp(MatrixF32& m_inv, const MatrixF32& m, float epsilon);

// Ch12_01_misc.cpp
extern void DisplayResults(MatrixF32& m_inv, MatrixF32& m_ver, bool rc,
    const char* msg, const char* fn, float epsilon);

// Ch12_01_bm.cpp
extern void Mat4x4InvF32_bm(void);

// Miscellaenous constants
constexpr int c_MatOstreamW = 12;           // MatrixF32 element ostream width
constexpr float c_Epsilon = 1.0e-5f;        // epsilon for singular matrix test    
