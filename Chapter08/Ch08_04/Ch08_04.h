//-----------------------------------------------------------------------------
// Ch08_04.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>
#include "XmmVal.h"

// Ch08_04_fasm.asm, Ch08_04_fasm.s
extern "C" void SllU16_avx(XmmVal* c, const XmmVal* a, uint32_t count);
extern "C" void SrlU16_avx(XmmVal* c, const XmmVal* a, uint32_t count);
extern "C" void SraU16_avx(XmmVal* c, const XmmVal* a, uint32_t count);
