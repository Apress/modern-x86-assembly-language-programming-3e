//-----------------------------------------------------------------------------
// Ch02_04.h
//-----------------------------------------------------------------------------

#pragma once

// Ch02_04_fasm.asm, Ch02_04_fasm.s
extern "C" long long AddSubI64a_a(long long a, long long b, long long c,
    long long d);
extern "C" long long AddSubI64b_a(long long a, long long b, long long c,
    long long d);

// Ch02_04_misc.cpp
extern void DisplayResults(const char* msg, long long a, long long b, long long c,
    long long d, long long r1, long long r2);
