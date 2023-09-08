//-----------------------------------------------------------------------------
// Ch08_03.h
//-----------------------------------------------------------------------------

#pragma once
#include "XmmVal.h"

// Ch08_03_fasm.asm, Ch08_03_fasm.s
extern "C" void AndU16_avx(XmmVal* c, const XmmVal* a, const XmmVal* b);
extern "C" void OrU16_avx(XmmVal* c, const XmmVal* a, const XmmVal* b);
extern "C" void XorU16_avx(XmmVal* c, const XmmVal* a, const XmmVal* b);
