//-----------------------------------------------------------------------------
// Ch02_02.h
//-----------------------------------------------------------------------------

#pragma once

// Ch02_02_fasm.asm, Ch02_02_fasm.s
extern "C" unsigned int BitOpsU32_a(unsigned int a, unsigned int b,
    unsigned int c, unsigned int d);

// Ch02_02_fcpp.cpp
unsigned int BitOpsU32_cpp(unsigned int a, unsigned int b, unsigned int c,
    unsigned int d);

// Ch02_02_misc.cpp
extern void DisplayResults(unsigned int a, unsigned int b, unsigned int c,
    unsigned int d, unsigned int r1, unsigned int r2);
