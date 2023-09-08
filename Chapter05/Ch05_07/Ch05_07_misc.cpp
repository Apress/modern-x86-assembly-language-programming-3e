//-----------------------------------------------------------------------------
// Ch05_07_misc.cpp
//-----------------------------------------------------------------------------

#include "Ch05_07.h"
#include "MT.h"

void InitArray(double* x, size_t n)
{
    MT::FillArrayFP(x, n, c_RngMin, c_RngMax, c_RngSeed);
}
