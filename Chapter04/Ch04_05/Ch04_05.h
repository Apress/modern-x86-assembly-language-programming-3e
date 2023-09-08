//-----------------------------------------------------------------------------
// Ch04_05.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch04_05_fasm.asm, Ch04_05_fasm.s
extern "C" int64_t CompareArrays_a(const int32_t* x, const int32_t* y, int64_t n);

// Ch04_05_fcpp.cpp
extern int64_t CompareArrays_cpp(const int32_t* x, const int32_t* y, int64_t n);

// Ch04_05_misc.cpp
extern void InitArrays(int32_t* x, int32_t* y, int64_t n, unsigned int rng_seed);
extern void DisplayResult(const char* msg, int64_t expected, int64_t result1,
    int64_t result2);
