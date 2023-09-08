//-----------------------------------------------------------------------------
// Ch08_01.h
//-----------------------------------------------------------------------------

#pragma once
#include "XmmVal.h"

// Ch08_01_fasm.asm, Ch08_01_fasm.s
extern "C" void AddI16_avx(XmmVal* c1, XmmVal* c2, const XmmVal* a,
    const XmmVal* b);

extern "C" void SubI16_avx(XmmVal* c1, XmmVal* c2, const XmmVal* a,
    const XmmVal* b);
