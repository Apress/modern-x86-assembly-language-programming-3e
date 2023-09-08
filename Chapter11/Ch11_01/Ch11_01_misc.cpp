//-----------------------------------------------------------------------------
// Ch11_01_misc.cpp
//-----------------------------------------------------------------------------

#include <cmath>
#include "Ch11_01.h"
#include "MT.h"

void InitArrays(double* x, double* y, size_t n)
{
    MT::FillArrayFP(x, n, c_RngMinVal, c_RngMaxVal, c_RngSeed1);
    MT::FillArrayFP(y, n, c_RngMinVal, c_RngMaxVal, c_RngSeed2);

    for (size_t i = 0; i < n; i++)
        y[i] = y[i] * y[i];
}
