//-----------------------------------------------------------------------------
// Ch14_01.h
//-----------------------------------------------------------------------------

#pragma once
#include "ZmmVal.h"

// Ch14_01_fasm.asm, Ch14_01_fasm.s
extern "C" void PackedMathF32_avx512(ZmmVal* c, const ZmmVal* a, const ZmmVal* b);
extern "C" void PackedMathF64_avx512(ZmmVal* c, const ZmmVal* a, const ZmmVal* b);
