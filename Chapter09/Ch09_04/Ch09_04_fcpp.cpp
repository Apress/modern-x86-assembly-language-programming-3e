//-----------------------------------------------------------------------------
// Ch09_04_fcpp.cpp
//-----------------------------------------------------------------------------

#include <cmath>
#include "Ch09_04.h"
#include "AlignedMem.h"

bool CalcMeanF64_cpp(double* mean, const double* x, size_t n)
{
    if (n < 2)
        return false;

    if (!AlignedMem::IsAligned(x, c_Alignment))
        return false;

    double sum = 0.0;

    for (size_t i = 0; i < n; i++)
        sum += x[i];

    *mean = sum / n;
    return true;
}

bool CalcStDevF64_cpp(double* st_dev, const double* x, size_t n, double mean)
{
    if (n < 2)
        return false;

    if (!AlignedMem::IsAligned(x, c_Alignment))
        return false;

    double sum_squares = 0.0;

    for (size_t i = 0; i < n; i++)
    {
        double temp = x[i] - mean;
        sum_squares += temp * temp;
    }

    *st_dev = sqrt(sum_squares / (n - 1));
    return true;
}
