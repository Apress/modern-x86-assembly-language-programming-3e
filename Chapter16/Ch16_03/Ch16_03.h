//-----------------------------------------------------------------------------
// Ch16_03.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch16_03_fasm.asm, Ch16_03_fasm.s
extern "C" bool AbsImage_avx2(uint8_t* pb_des, const uint8_t* pb_src0,
    const uint8_t* pb_src1, size_t num_pixels);

// Ch16_03_fasm2.asm, Ch16_03_fasm2.s
extern "C" bool AbsImageNT_avx2(uint8_t* pb_des, const uint8_t* pb_src0,
    const uint8_t* pb_src1, size_t num_pixels);

// Ch16_03_fcpp.cpp
extern bool AbsImage_cpp(uint8_t* pb_des, const uint8_t* pb_src0,
    const uint8_t* pb_src1, size_t num_pixels);

// Ch16_03_misc.cpp
extern "C" bool CheckArgs(const uint8_t* pb_des, const uint8_t* pb_src0,
    const uint8_t* pb_src1, size_t num_pixels);

// Ch16_03_bm.cpp
extern void AbsImage_bm();

// Miscellaneous globals
extern const char* g_ImageFileName0;
extern const char* g_ImageFileName1;
