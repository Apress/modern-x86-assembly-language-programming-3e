//-----------------------------------------------------------------------------
// Ch08_06_fcpp.cpp
//-----------------------------------------------------------------------------

#include "Ch08_06.h"
#include "AlignedMem.h"

bool CalcMeanU8_cpp(double* mean_x, uint64_t* sum_x, const uint8_t* x,
    uint32_t n)
{
    // Validate arguments
    if (n <= 0 || (n % 64) != 0)
        return false;

    if (!AlignedMem::IsAligned(x, c_Alignment))
        return false;

    // Calculate pixel mean
    uint64_t sum_x_temp = 0;

    for (size_t i = 0; i < n; i++)
        sum_x_temp += x[i];

    *sum_x = sum_x_temp;
    *mean_x = (double)sum_x_temp / n;
    return true;
}
