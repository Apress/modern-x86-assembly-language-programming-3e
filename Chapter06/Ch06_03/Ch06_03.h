//-----------------------------------------------------------------------------
// Ch06_03.h
//-----------------------------------------------------------------------------

#pragma once

// Ch06_03_fasm.asm
extern "C" bool CalcConeAreaVol_avx(const double* r, const double* h, int n,
    double* sa_cone, double* vol_cone);

// Ch06_03_fcpp.cpp
extern "C" double g_F64_PI;

extern bool CalcConeAreaVol_cpp(const double* r, const double* h, int n,
    double* sa_cone, double* vol_cone);
