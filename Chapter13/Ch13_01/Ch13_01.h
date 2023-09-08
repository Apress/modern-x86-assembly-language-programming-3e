//-----------------------------------------------------------------------------
// Ch13_01.h
//-----------------------------------------------------------------------------

#pragma once
#include "ZmmVal.h"

// Ch13_01_fasm.asm, Ch13_01_fasm.s
extern "C" void MathI16_avx512(ZmmVal* c, const ZmmVal* a, const ZmmVal* b);
extern "C" void MathI64_avx512(ZmmVal* c, const ZmmVal* a, const ZmmVal* b);
