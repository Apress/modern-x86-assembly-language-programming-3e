//-----------------------------------------------------------------------------
// Ch08_06.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch08_06_fasm.asm, Ch08_06_fasm.s
extern "C" bool CalcMeanU8_avx(double* mean_x, uint64_t* sum_x, const uint8_t* x,
    uint32_t n);

// Ch08_06_fcpp.cpp
extern bool CalcMeanU8_cpp(double* mean_x, uint64_t* sum_x, const uint8_t* x,
    uint32_t n);

// Ch08_06_misc.cpp
extern void InitArray(uint8_t* x, uint32_t n, unsigned int seed);

// Miscellaneous constants
constexpr size_t c_Alignment = 16;
constexpr uint32_t c_NumElements = 16384;
constexpr unsigned int c_RngSeedVal = 29;
