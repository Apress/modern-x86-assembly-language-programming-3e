//-----------------------------------------------------------------------------
// Ch13_03.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Note: any changes to CmpOp must also be reflected in the assembly
// language files.
enum class CmpOp : uint64_t { EQ, NE, LT, LE, GT, GE };

// Ch13_03_fasm.asm, Ch13_03_fasm.s
extern "C" void ComparePixels_avx512(uint8_t * des, const uint8_t * src,
    size_t num_pixels, CmpOp cmp_op, uint8_t cmp_val);

// Ch13_03_fcpp.cpp
extern void ComparePixels_cpp(uint8_t* des, const uint8_t* src, size_t num_pixels,
    CmpOp cmp_op, uint8_t cmp_val);

// Ch13_03_misc.cpp
extern bool CheckArgs(const uint8_t* des, const uint8_t* src, size_t num_pixels);
extern void DisplayResults(const uint8_t* des1, const uint8_t* des2,
    size_t num_pixels, CmpOp cmp_op, uint8_t cmp_val, size_t test_id);
extern void InitArray(uint8_t* x, size_t n, unsigned int seed);

// Miscellaneous constants
const size_t c_Alignment = 64;
