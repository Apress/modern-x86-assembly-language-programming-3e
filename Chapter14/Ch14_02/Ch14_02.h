//-----------------------------------------------------------------------------
// Ch14_02.h
//-----------------------------------------------------------------------------

#pragma once
#include "ZmmVal.h"

// Ch14_02_fasm.asm, Ch14_02_fasm.s
extern "C" void PackedCompareF32_avx512(uint16_t* c, const ZmmVal* a,
    const ZmmVal* b);
extern "C" void PackedCompareF64_avx512(uint8_t* c, const ZmmVal* a,
    const ZmmVal* b);
