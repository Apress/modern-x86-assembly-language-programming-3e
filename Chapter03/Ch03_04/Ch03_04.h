//-----------------------------------------------------------------------------
// Ch03_04.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch03_04_fasm.asm, Ch03_04_fasm.s
extern "C" int32_t SignedMin1_a(int32_t a, int32_t b, int32_t c);
extern "C" int32_t SignedMin2_a(int32_t a, int32_t b, int32_t c);
extern "C" int32_t SignedMax1_a(int32_t a, int32_t b, int32_t c);
extern "C" int32_t SignedMax2_a(int32_t a, int32_t b, int32_t c);

// Ch03_04_misc.cpp
void DisplayResults(const char* s1, int32_t a, int32_t b, int32_t c, int32_t result);
