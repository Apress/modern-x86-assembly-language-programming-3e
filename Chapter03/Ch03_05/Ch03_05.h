//-----------------------------------------------------------------------------
// Ch03_05.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch03_05_fasm.asm, Ch03_05_fasm.s
extern "C" bool CalcSumCubes_a(int64_t* sum, int64_t n);

// Ch03_05_fcpp.cpp
extern bool CalcSumCubes_cpp(int64_t* sum, int64_t n);

// Ch03_05_misc.cpp
extern void DisplayResults(int id, int64_t n, int64_t sum1, bool rc1,
    int64_t sum2, bool rc2);

// Ch03_05.cpp
extern "C" int64_t g_ValMax;
