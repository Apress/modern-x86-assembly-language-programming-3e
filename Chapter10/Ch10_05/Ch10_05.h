//-----------------------------------------------------------------------------
// Ch10_05.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch10_05_fasm.asm, Ch10_05_fasm.s
extern "C" void ConvertU8ToF32_avx2(float* pb_des, const uint8_t * pb_src,
    size_t num_pixels);

// Ch10_05_fcpp.cpp
extern void ConvertU8ToF32_cpp(float* pb_des, const uint8_t* pb_src,
    size_t num_pixels);

// Ch10_05_misc.cpp
extern void BuildLUT_U8ToF32(void);
extern size_t CompareArraysF32(const float* pb_src1, const float* pb_src2,
    size_t num_pixels);
extern void InitArray(uint8_t* pb, size_t num_pixels);

extern "C" float g_LUT_U8ToF32[];

// Ch10_05_bm.cpp
extern void ConvertU8ToF32_bm(void);

// Miscellaneous constants
constexpr size_t c_Alignment = 32;
constexpr size_t c_NumPixels = 1024 * 1024 + 19;
constexpr size_t c_NumPixelsBM = 10000000;
constexpr int c_FillMinVal = 0;
constexpr int c_FillMaxVal = 255;
constexpr unsigned int c_RngSeed = 71;
