//-----------------------------------------------------------------------------
// Ch04_08.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Test structure

struct TestStruct
{
    int8_t  Val8;
    int64_t Val64;
    int16_t Val16;
    int32_t Val32;
};

// Ch04_08_fasm.asm, Ch04_08_fasm.s
extern "C" int64_t SumStructVals_a(const TestStruct* ts);

// Ch04_08_misc.cpp
extern void DisplayResults(const TestStruct& ts, int64_t sum1, int64_t sum2);
