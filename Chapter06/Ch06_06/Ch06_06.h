//-----------------------------------------------------------------------------
// Ch06_06.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch06_06_fasm.asm
extern "C" int64_t AddIntegers_a(int8_t a, int16_t b, int32_t c, int64_t d,
    int8_t e, int16_t f, int32_t g, int64_t h);

// Ch06_06_fcpp.cpp
extern int64_t AddIntegers_cpp(int8_t a, int16_t b, int32_t c, int64_t d,
    int8_t e, int16_t f, int32_t g, int64_t h);
