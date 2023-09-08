//-----------------------------------------------------------------------------
// Ch10_04.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>
#include "ImageMisc.h"

// Ch10_04_fasm.asm, Ch10_04_fasm.s
extern "C" void ConvertRgbToGs_avx2(uint8_t* pb_gs, const RGB32* pb_rgb,
    size_t num_pixels, const float coef[4]);

// Ch10_04_fcpp.cpp
extern void ConvertRgbToGs_cpp(uint8_t* pb_gs, const RGB32* pb_rgb,
    size_t num_pixels, const float coef[4]);

// Ch10_04_misc.cpp
extern void ConvertRgbToGs_bm(void);
extern bool CompareGsPixelBuffers(const uint8_t* pb_gs1, const uint8_t* pb_gs2,
    size_t num_pixels);

// Ch15_04.cpp
extern const float c_Coef[4];
extern const char* c_TestImageFileName;

// Ch10_04_bm.cpp
void ConvertRgbToGs_bm(void);

// Miscellaneous constants
constexpr size_t c_Alignment = 32;
