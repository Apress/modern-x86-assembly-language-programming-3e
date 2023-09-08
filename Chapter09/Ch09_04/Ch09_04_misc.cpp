//-----------------------------------------------------------------------------
// Ch09_04_misc.cpp
//-----------------------------------------------------------------------------

#include "Ch09_04.h"
#include "MT.h"

void InitArray(double* x, size_t n)
{
    MT::FillArrayFP(x, n, c_RngMin, c_RngMax, c_RngSeed);
}
