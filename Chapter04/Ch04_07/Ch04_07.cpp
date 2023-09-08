//-----------------------------------------------------------------------------
// Ch04_07.cpp
//-----------------------------------------------------------------------------

#include "Ch04_07.h"

int main(void)
{
    constexpr int32_t n = 25;
    int32_t y[n], x[n];

    InitArrays(y, x, n);

    int rc = ReverseArrayI32_a(y, x, n);
    DisplayResults(y, x, n, rc);
    return 0;
}

