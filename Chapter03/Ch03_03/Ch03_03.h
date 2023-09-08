//-----------------------------------------------------------------------------
// Ch03_03.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch03_03_fasm.asm, Ch03_03_fasm.s
extern "C" int g_NumPrimes_a;
extern "C" int g_SumPrimes_a;

extern "C" int MemAddressing_a(int32_t i, int32_t* v1, int32_t* v2,
    int32_t* v3, int32_t* v4);

// Ch03_03_misc.cpp
extern void DisplayResults(int32_t i, int32_t rc, int32_t v1, int32_t v2,
    int32_t v3, int32_t v4);
