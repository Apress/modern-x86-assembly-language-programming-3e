//-----------------------------------------------------------------------------
// Ch16_02.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Values in namespace CpuFlags must match the equ statements
// in the assembly language files. Values must also be
// consecutively numbered starting from zero.

namespace CpuidFlags
{
    constexpr size_t POPCNT = 0;
    constexpr size_t AVX = 1;
    constexpr size_t AVX2 = 2;
    constexpr size_t FMA = 3;
    constexpr size_t AVX512F = 4;
    constexpr size_t AVX512VL = 5;
    constexpr size_t AVX512DQ = 6;
    constexpr size_t AVX512BW = 7;
    constexpr size_t AVX512_VMBI = 8;
    constexpr size_t AVX512_VMBI2 = 9;
    constexpr size_t AVX512_FP16 = 10;
    constexpr size_t AVX512_BF16 = 11;
    constexpr size_t NUM_FLAGS = 12;
};

// Ch16_02_fasm.asm, Ch16_02_fasm.s
extern "C" bool GetCpuidFlags_a(uint8_t* flags, size_t flags_len);

// Ch16_02_fasm2.asm, Ch16_02_fasm2.s
extern "C" int GetProcessorVendorInfo_a(char* vendor, size_t vendor_len,
    char* brand, size_t brand_len);
