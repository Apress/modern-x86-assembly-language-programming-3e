//-----------------------------------------------------------------------------
// Ch07_01.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>

// Ch07_01_fasm.asm, Ch07_01_fasm.s
extern "C" void CalcZ_avx(float* z, const float* x, const float* y, size_t n);

// Ch07_01_fcpp.cpp
extern void CalcZ_cpp(float* z, const float* x, const float* y, size_t n);
