//-----------------------------------------------------------------------------
// Ch02_03.h
//-----------------------------------------------------------------------------

#pragma once

// Ch02_03_fasm.asm, Ch02_03_fasm.s
extern "C" int ShiftU32_a(unsigned int* a_shl, unsigned int* a_shr,
    unsigned int a, unsigned int count);

// Ch02_03_misc.cpp
extern void DisplayResults(const char* s, int rc, unsigned int a,
    unsigned int count, unsigned int a_shl, unsigned int a_shr);
