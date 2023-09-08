//-----------------------------------------------------------------------------
// Ch03_05_fcpp.cpp
//-----------------------------------------------------------------------------

#include "Ch03_05.h"

bool CalcSumCubes_cpp(int64_t* sum, int64_t  n)
{
    if (n <= 0 || n > g_ValMax)
    {
        *sum = 0;
        return false;
    }

    int64_t temp1 = n * (n + 1) / 2;

    *sum = temp1 * temp1;
    return true;
}
