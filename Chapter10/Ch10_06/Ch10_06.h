//-----------------------------------------------------------------------------
// Ch10_06.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch10_06_fasm.asm, Ch10_06_fasm.s
extern "C" bool BuildHistogram_avx2(uint32_t * histo, const uint8_t * pixel_buff,
    size_t num_pixels);

// Ch10_06_fcpp.cpp
extern bool BuildHistogram_cpp(uint32_t* histo, const uint8_t* pixel_buff,
    size_t num_pixels);

// Ch10_06_misc.cpp
extern void SaveHistograms(const uint32_t* histo0, const uint32_t* histo1,
    size_t histo_size, bool rc0, bool rc1);

// Ch10_06_bm.cpp
extern void BuildHistogram_bm(void);

// Miscellaneous globals and constants
extern const char* g_ImageFileName;
constexpr size_t c_HistoSize = 256;     // Number of histogram bins
constexpr size_t c_Alignment = 32;
