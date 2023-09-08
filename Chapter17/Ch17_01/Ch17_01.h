//-----------------------------------------------------------------------------
// Ch17_01.h
//-----------------------------------------------------------------------------

#pragma once

// Ch17_01_fasm.asm, Ch17_01_fasm.s
extern "C" bool CalcResult_avx(double* y, const double* x, size_t n);

// Ch17_01_fcpp.cpp
extern bool CalcResult_cpp(double* y, const double* x, size_t n);

// Miscellaneous constants
constexpr size_t c_Alignment = 32;
constexpr size_t c_ArraySize = 1000;
