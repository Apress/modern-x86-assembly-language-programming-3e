//-----------------------------------------------------------------------------
// Ch04_03.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch04_03_fasm.asm, Ch04_03_fasm.s
extern "C" void CalcMat2dSquares_a(int32_t* y, const int32_t* x, size_t m,
    size_t n);

// Ch04_03_fcpp.cpp
extern void CalcMat2dSquares_cpp(int32_t* y, const int32_t* x, size_t m,
    size_t n);

// Ch04_03_misc.cpp
extern void DisplayResults(const int32_t* y1, const int32_t* y2, const int32_t* x,
    size_t m, size_t n);
