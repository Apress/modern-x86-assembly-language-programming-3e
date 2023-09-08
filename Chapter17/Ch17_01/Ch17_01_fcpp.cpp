//-----------------------------------------------------------------------------
// Ch17_01_fcpp.cpp
//-----------------------------------------------------------------------------

#include <cmath>
#include "Ch17_01.h"
#include "AlignedMem.h"

bool CalcResult_cpp(double* y, const double* x, size_t n)
{
    if (n == 0)
        return false;

    if (n % 8 != 0)
        return false;

    if (!AlignedMem::IsAligned(x, c_Alignment))
        return false;

    if (!AlignedMem::IsAligned(y, c_Alignment))
        return false;

    for (size_t i = 0; i < n; i++)
        y[i] = sqrt(x[i] / 2.0);

    return true;
}
