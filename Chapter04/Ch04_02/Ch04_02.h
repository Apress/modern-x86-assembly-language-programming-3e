//-----------------------------------------------------------------------------
// Ch04_02.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch04_02_fasm.asm, Ch04_02_fasm.s
extern "C" void CalcArrayVals_a(int64_t* c, const int64_t* a, const int64_t* b,
    size_t n);

// Ch04_02_fcpp.cpp
extern void CalcArrayVals_cpp(int64_t* c, const int64_t* a, const int64_t* b,
    size_t n);

// Ch04_02_misc.cpp
extern void FillArrays(int64_t* c1, int64_t* c2, int64_t* a, int64_t* b, size_t n);

extern void DisplayResults(const int64_t* c1, const int64_t* c2, const int64_t* a,
    const int64_t* b, size_t n);
