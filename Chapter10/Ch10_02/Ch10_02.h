//-----------------------------------------------------------------------------
// Ch10_02.h
//-----------------------------------------------------------------------------

#pragma once
#include "YmmVal.h"

// Ch10_02_fasm.asm, Ch10_02_fasm.s
extern "C" void ZeroExtU8_U16_avx2(YmmVal* c, const YmmVal* a);
extern "C" void ZeroExtU8_U32_avx2(YmmVal* c, const YmmVal* a);
extern "C" void SignExtI16_I32_avx2(YmmVal* c, const YmmVal* a);
extern "C" void SignExtI16_I64_avx2(YmmVal* c, const YmmVal* a);
