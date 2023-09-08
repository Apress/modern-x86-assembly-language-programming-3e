//-----------------------------------------------------------------------------
// Ch02_05.h
//-----------------------------------------------------------------------------

#pragma once

// Ch02_05_fasm.asm, Ch02_05_fasm.s
extern "C" void MulI32_a(int* prod1, long long* prod2, int a, int b);
extern "C" int DivI32_a(int* quo, int* rem, int a, int b);

// Ch02_05_misc.cpp
extern void DisplayResults(int test_id, int a, int b, int prod1,
    long long prod2, int quo, int rem, int rc);
