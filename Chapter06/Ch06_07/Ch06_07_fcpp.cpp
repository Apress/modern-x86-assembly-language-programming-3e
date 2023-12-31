//-----------------------------------------------------------------------------
// Ch06_07_fcpp.cpp
//-----------------------------------------------------------------------------

#include <cmath>
#include "Ch06_07.h"

bool CalcBSA_cpp(const double* ht, const double* wt, int n, double* bsa1,
    double* bsa2, double* bsa3, double* bsa_mean)
{
    if (n <= 0)
        return false;

    for (int i = 0; i < n; i++)
    {
        bsa1[i] = 0.007184 * pow(ht[i], 0.725) * pow(wt[i], 0.425);
        bsa2[i] = 0.0235 * pow(ht[i], 0.42246) * pow(wt[i], 0.51456);
        bsa3[i] = sqrt(ht[i] * wt[i] / 3600.0);

        bsa_mean[i] = (bsa1[i] + bsa2[i] + bsa3[i]) / 3.0;
    }

    return true;
}
