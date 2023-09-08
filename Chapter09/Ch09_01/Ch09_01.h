//-----------------------------------------------------------------------------
// Ch09_01.h
//-----------------------------------------------------------------------------

#pragma once
#include "YmmVal.h"

// Ch09_01_fasm.asm, Ch09_01_fasm.s
extern "C" void PackedMathF32_avx(YmmVal* c, const YmmVal* a, const YmmVal* b);
extern "C" void PackedMathF64_avx(YmmVal* c, const YmmVal* a, const YmmVal* b);
