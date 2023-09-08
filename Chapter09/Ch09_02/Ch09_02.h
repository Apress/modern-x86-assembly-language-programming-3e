//-----------------------------------------------------------------------------
// Ch09_02.h
//-----------------------------------------------------------------------------

#pragma once
#include "YmmVal.h"

// Ch09_02_fasm.asm, Ch09_02_fasm.s
extern "C" void PackedCompareF32_avx(YmmVal* c, const YmmVal* a, const YmmVal* b);
extern "C" void PackedCompareF64_avx(YmmVal* c, const YmmVal* a, const YmmVal* b);
