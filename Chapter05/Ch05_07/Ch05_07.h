//-----------------------------------------------------------------------------
// Ch05_07.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>

// Ch05_07_fasm.asm, Ch05_07_fasm.s
extern "C" bool CalcMeanF64_avx(double* mean, const double* x, size_t n);
extern "C" bool CalcStDevF64_avx(double* st_dev, const double* x, size_t n,
    double mean);

// Ch05_07_fcpp.cpp
extern bool CalcMeanF64_cpp(double* mean, const double* x, size_t n);
extern bool CalcStDevF64_cpp(double* st_dev, const double* x, size_t n,
    double mean);

// Ch05_07_misc.cpp
extern void InitArray(double* x, size_t n);

// Miscellaneous constants
constexpr size_t c_NumElements = 91;
constexpr double c_RngMin = 1.0;
constexpr double c_RngMax = 100.0;
constexpr unsigned int c_RngSeed = 13;
