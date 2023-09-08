//-----------------------------------------------------------------------------
// Ch05_02.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>

// Ch05_02_fasm.asm, Ch05_02_fasm.s
extern "C" void CalcConeVolSA_avx(float* vol, float* sa, float r, float h);

// Ch05_02_fcpp.cpp
extern "C" float g_F32_PI;
extern void CalcConeVolSA_cpp(float* vol, float* sa, float r, float h);

// Ch05_02_misc.cpp
extern void DisplayResults(size_t i, float r, float h, float vol1, float sa1,
    float vol2, float sa2);
