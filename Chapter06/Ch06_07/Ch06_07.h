//-----------------------------------------------------------------------------
// Ch06_07.h
//-----------------------------------------------------------------------------

#pragma once

// Ch06_07_fasm.asm
extern "C" bool CalcBSA_avx(const double* ht, const double* wt, int n,
    double* bsa1, double* bsa2, double* bsa3, double* bsa_mean);

// Ch06_07_fcpp.cpp
extern bool CalcBSA_cpp(const double* ht, const double* wt, int n,
    double* bsa1, double* bsa2, double* bsa3, double* bsa_mean);
