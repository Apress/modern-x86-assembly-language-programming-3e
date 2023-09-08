//-----------------------------------------------------------------------------
// Ch08_05.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch08_05_fasm.asm, Ch08_05_fasm.s
extern "C" bool CalcMinMaxU8_avx(uint8_t* x_min, uint8_t* x_max,
    const uint8_t* x, size_t n);

// Ch08_05_fcpp.cpp
extern bool CalcMinMaxU8_cpp(uint8_t* x_min, uint8_t* x_max,
    const uint8_t* x, size_t n);

// Ch08_05_misc.cpp
extern void InitArray(uint8_t* x, size_t n, unsigned int rng_seed);

// c_NumElements must be > 0 and even multiple of 16
constexpr size_t c_NumElements = 10000000;
constexpr unsigned int c_RngSeedVal = 23;
