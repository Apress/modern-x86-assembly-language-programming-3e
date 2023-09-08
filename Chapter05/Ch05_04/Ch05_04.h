//-----------------------------------------------------------------------------
// Ch05_04.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch05_04_fasm.asm, Ch05_04_fasm.s
extern "C" void CompareF32_avx(uint8_t* cmp_results, float a, float b);

// Ch05_04_misc.cpp
extern void DisplayResults(const uint8_t* cmp_results, float a, float b);

// Miscellaenous constants
constexpr size_t c_NumCmpOps = 7;
