//-----------------------------------------------------------------------------
// Ch13_02.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>
#include "ZmmVal.h"

// Ch13_02_fasm.asm, Ch13_02_fasm.s
extern "C" void MaskOpI64a_avx512(ZmmVal* c, uint8_t mask, const ZmmVal* a,
    const ZmmVal* b);
extern "C" void MaskOpI64b_avx512(ZmmVal* c, uint8_t mask, const ZmmVal* a,
    const ZmmVal* b1, const ZmmVal* b2);
extern "C" void MaskOpI64c_avx512(ZmmVal* c, const ZmmVal* a, int64_t x1,
    int64_t x2);

