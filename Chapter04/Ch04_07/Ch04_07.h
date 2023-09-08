//-----------------------------------------------------------------------------
// Ch04_07.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch04_07_fasm.asm, Ch04_07_fasm.s
extern "C" int ReverseArrayI32_a(int32_t* y, const int32_t* x, int32_t n);

// Ch04_07_misc.cpp
void InitArrays(int32_t* y, int32_t* x, int32_t n);
void DisplayResults(const int32_t* y, const int32_t* x, int32_t n, int rc);
