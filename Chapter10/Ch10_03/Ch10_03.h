//-----------------------------------------------------------------------------
// Ch10_03.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// The members of ClipData must match the corresponding structure
// that's declared in the assembly langage files.

struct ClipData
{
    uint8_t* m_PbSrc;               // source buffer pointer
    uint8_t* m_PbDes;               // destination buffer pointer
    size_t m_NumPixels;             // number of pixels
    size_t m_NumClippedPixels;      // number of clipped pixels
    uint8_t m_ThreshLo;             // low threshold
    uint8_t m_ThreshHi;             // high threshold
};

// Ch10_03_fasm.asm, Ch10_03_fasm.s
extern "C" void ClipPixels_avx2(ClipData * clip_data);

// Ch10_03_fcpp.cpp
extern void ClipPixels_cpp(ClipData* clip_data);

// Ch10_03_misc.cpp
extern void InitPixelBuffer(uint8_t* pb, size_t num_pixels);

// Ch10_03_bm.cpp
extern void ClipPixels_bm(void);

// Miscellaneous constants
constexpr size_t c_Alignment = 32;
constexpr int c_RngMinVal = 0;
constexpr int c_RngMaxVal = 255;
constexpr unsigned int c_RngSeed = 157;
constexpr uint8_t c_ThreshLo = 10;
constexpr uint8_t c_ThreshHi = 245;
constexpr size_t c_NumPixels = 8 * 1024 * 1024 + 31;
constexpr size_t c_NumPixelsBM = 10000000;
