//-----------------------------------------------------------------------------
// Ch09_05_fcpp.cpp
//-----------------------------------------------------------------------------

#include <cmath>
#include "Ch09_05.h"

bool CalcDistances_cpp(double* d, const double* x1, const double* y1,
    const double* x2, const double* y2, size_t n, double thresh)
{
    if (!CheckArgs(d, x1, y1, x2, y2, n))
        return false;

    for (size_t i = 0; i < n; i++)
    {
        double temp1 = x1[i] - x2[i];
        double temp2 = y1[i] - y2[i];
        double dist = sqrt(temp1 * temp1 + temp2 * temp2);

        d[i] = (dist >= thresh) ? dist * -1.0 : dist;
    }

    return true;
}
