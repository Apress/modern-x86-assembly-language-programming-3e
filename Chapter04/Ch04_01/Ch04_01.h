//-----------------------------------------------------------------------------
// Ch04_01.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch04_01_fasm.asm, Ch04_01_fasm.s
extern "C" int64_t SumElementsI32_a(const int32_t* x, size_t n);

// Ch04_01_fcpp.cpp
extern int64_t SumElementsI32_cpp(const int32_t* x, size_t n);

// Ch04_01_misc.cpp
extern void FillArray(int32_t* x, size_t n);
extern void DisplayResults(const int32_t* x, size_t n, int64_t sum1, int64_t sum2);
