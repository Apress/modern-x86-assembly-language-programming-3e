//-----------------------------------------------------------------------------
// Ch04_05_fcpp.cpp
//-----------------------------------------------------------------------------

#include "Ch04_05.h"

int64_t CompareArrays_cpp(const int32_t* x, const int32_t* y, int64_t n)
{
    if (n <= 0)
        return -1;

    int64_t i = 0;

    while (i < n)
    {
        if (x[i] != y[i])
            break;

        i++;
    }

    return i;
}
