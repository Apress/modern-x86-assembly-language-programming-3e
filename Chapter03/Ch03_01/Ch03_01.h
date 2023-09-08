//-----------------------------------------------------------------------------
// Ch03_01.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch03_01_fasm.asm, Ch03_01_fasm.s
extern "C" int32_t SumValsI32_a(int32_t a, int32_t b, int32_t c, int32_t d,
    int32_t e, int32_t f, int32_t g, int32_t h);

extern "C" uint64_t MulValsU64_a(uint64_t a, uint64_t b, uint64_t c, uint64_t d,
    uint64_t e, uint64_t f, uint64_t g, uint64_t h);

// Ch03_01_misc.cpp
void DisplayResults(int32_t a, int32_t b, int32_t c, int32_t d, int32_t e,
    int32_t f, int32_t g, int32_t h, int32_t result1, int32_t result2);

void DisplayResults(uint64_t a, uint64_t b, uint64_t c, uint64_t d, uint64_t e,
    uint64_t f, uint64_t g, uint64_t h, uint64_t result1, uint64_t result2);
