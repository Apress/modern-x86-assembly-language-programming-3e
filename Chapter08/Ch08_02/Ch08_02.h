//-----------------------------------------------------------------------------
// Ch08_02.h
//-----------------------------------------------------------------------------

#pragma once
#include "XmmVal.h"

// Ch08_02_fasm.asm
extern "C" void MulI16_avx(XmmVal c[2], const XmmVal* a, const XmmVal* b);
extern "C" void MulI32a_avx(XmmVal* c, const XmmVal* a, const XmmVal* b);
extern "C" void MulI32b_avx(XmmVal c[2], const XmmVal* a, const XmmVal* b);
