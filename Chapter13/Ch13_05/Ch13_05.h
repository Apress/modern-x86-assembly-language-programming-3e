//-----------------------------------------------------------------------------
// Ch13_05.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch13_05_fasm.asm, Ch13_05_fasm.s
extern "C" bool BuildHistogram_avx512(uint32_t* histo, const uint8_t* pixel_buff,
    size_t num_pixels);

// Ch13_05_fcpp.cpp
extern bool BuildHistogram_cpp(uint32_t* histo, const uint8_t* pixel_buff,
    size_t num_pixels);

// Ch13_05_misc.cpp
extern void SaveHistograms(const uint32_t* histo0, const uint32_t* histo1,
    size_t histo_size, bool rc0, bool rc1);

// Ch13_05_bm.cpp
extern void BuildHistogram_bm(void);

// Miscellaneous globals and constants
extern const char* g_ImageFileName;
constexpr size_t c_HistoSize = 256;     // Number of histogram bins
constexpr size_t c_Alignment = 64;
