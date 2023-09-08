//-----------------------------------------------------------------------------
// Ch13_04.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Simple image statistics structure. This must match the structure that's
// defined in Ch13_04_fasm.asm

struct ImageStats
{
    uint8_t* m_PixelBuffer;
    uint32_t m_PixelMinVal;
    uint32_t m_PixelMaxVal;
    size_t m_NumPixels;
    size_t m_NumPixelsInRange;
    uint64_t m_PixelSum;
    uint64_t m_PixelSumSquares;
    double m_PixelMean;
    double m_PixelStDev;
};

// Ch13_04_fasm.cpp, Ch13_04_fasm.s
extern "C" void CalcImageStats_avx512(ImageStats& im_stats);

// Ch13_04_fcpp.cpp
extern void CalcImageStats_cpp(ImageStats& im_stats);

// Ch13_04_misc.cpp
extern "C" bool CheckArgs(const ImageStats& im_stats);

// Ch13_04_bm.cpp
extern void CalcImageStats_bm(void);

// Miscellaneous globals and constants
extern const char* g_ImageFileName;
constexpr size_t c_Alignment = 64;
constexpr uint32_t c_PixelMinVal = 40;
constexpr uint32_t c_PixelMaxVal = 230;
