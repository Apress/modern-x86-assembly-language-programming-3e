//-----------------------------------------------------------------------------
// Ch05_03.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>

// Ch05_03_fasm.asm, Ch05_03_fasm.s
extern "C" void CalcSphereVolSA_avx(double* vol, double* sa, double r);

// Ch05_03_fcpp.cpp
extern "C" double g_F64_PI;
extern void CalcSphereVolSA_cpp(double* vol, double* sa, double r);

// Ch05_03_misc.cpp
extern void DisplayResults(size_t i, double r, double vol1, double sa1,
    double vol2, double sa2);
