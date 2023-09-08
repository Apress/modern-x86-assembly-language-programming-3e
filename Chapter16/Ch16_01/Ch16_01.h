//-----------------------------------------------------------------------------
// Ch16_01.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>

// Ch16_01_fasm.asm, Ch16_01_fasm.s
extern "C" int GetProcessorVendorInfo_a(char* vendor, size_t vendor_len,
    char* brand, size_t brand_len);
