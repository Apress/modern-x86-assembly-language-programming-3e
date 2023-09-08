//-----------------------------------------------------------------------------
// Ch04_03_fcpp.cpp
//-----------------------------------------------------------------------------

#include "Ch04_03.h"

void CalcMat2dSquares_cpp(int32_t* y, const int32_t* x, size_t m, size_t n)
{
    // Calculate y[i][i] = x[j][i] * x[j][i]

    for (size_t i = 0; i < m; i++)
    {
        for (size_t j = 0; j < n; j++)
        {
            size_t kx = j * m + i;
            size_t ky = i * n + j;

            y[ky] = x[kx] * x[kx];
        }
    }
}

