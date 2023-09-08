//-----------------------------------------------------------------------------
// Ch14_03.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>

// Ch14_03_fasm.asm, Ch14_03_fasm.s
extern "C" bool CalcDistances_avx512(double* d, const double* x1, const double* y1,
    const double* x2, const double* y2, size_t n, double thresh);

// Ch14_03_fcpp.cpp
extern bool CalcDistances_cpp(double* d, const double* x1, const double* y1,
    const double* x2, const double* y2, size_t n, double thresh);

// Ch14_03_misc.cpp
extern "C" bool CheckArgs(const double* d, const double* x1, const double* y1,
    const double* x2, const double* y2, size_t n);

extern void DisplayResults(const double* d1, const double* d2, const double* x1,
    const double* y1, const double* x2, const double* y2, size_t n, double thresh);

extern void InitArrays(double* x1, double* y1, double* x2, double* y2, size_t n);

// Miscellaneous constants
constexpr size_t c_Alignment = 64;
constexpr size_t c_NumPoints = 24;      // Must be > 0 and evely divisble by 8
constexpr double c_Thresh = 25.0;
