//-----------------------------------------------------------------------------
// Ch10_01.h
//-----------------------------------------------------------------------------

#pragma once
#include "YmmVal.h"

// Ch10_01_fasm.asm, Ch10_01_fasm.s
extern "C" void MathI16_avx2(YmmVal* c, const YmmVal* a, const YmmVal* b);
extern "C" void MathI32_avx2(YmmVal* c, const YmmVal* a, const YmmVal* b);
