//-----------------------------------------------------------------------------
// Ch03_02.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch03_01_fasm.asm, Ch03_01_fasm.s
extern "C" int64_t CalcResultI64_a(int8_t a, int16_t b, int32_t c, int64_t d,
    int8_t e, int16_t f, int32_t g, int64_t h);

extern "C" void CalcResultU64_a(uint8_t a, uint16_t b, uint32_t c, uint64_t d,
    uint8_t e, uint16_t f, uint32_t g, uint64_t h, uint64_t* quo, uint64_t* rem);

// Ch03_02_misc.cpp
void DisplayResults(int8_t a, int16_t b, int32_t c, int64_t d,
    int8_t e, int16_t f, int32_t g, int64_t h, int64_t prod1, int64_t prod2);

void DisplayResults(uint8_t a, uint16_t b, uint32_t c, uint64_t d,
    uint8_t e, uint16_t f, uint32_t g, uint64_t h,
    uint64_t quo1, uint64_t rem1, uint64_t quo2, uint64_t rem2);
