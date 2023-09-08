//-----------------------------------------------------------------------------
// Ch06_03_fcpp.cpp
//-----------------------------------------------------------------------------

#include <cmath>
#include <numbers>
#include "Ch06_03.h"

double g_F64_PI = std::numbers::pi_v<double>;     // used in asm code

bool CalcConeAreaVol_cpp(const double* r, const double* h, int n,
    double* sa_cone, double* vol_cone)
{
    constexpr double pi = std::numbers::pi_v<double>;

    if (n <= 0)
        return false;

    for (int i = 0; i < n; i++)
    {
        sa_cone[i] = pi * r[i] * (r[i] + sqrt(r[i] * r[i] + h[i] * h[i]));
        vol_cone[i] = pi * r[i] * r[i] * h[i] / 3.0;
    }

    return true;
}
