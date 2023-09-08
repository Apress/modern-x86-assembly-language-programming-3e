//-----------------------------------------------------------------------------
// Ch04_02.cpp
//-----------------------------------------------------------------------------

#include "Ch04_02.h"

int main()
{
    constexpr size_t n = 20;
    int64_t a[n], b[n], c1[n], c2[n];

    FillArrays(c1, c2, a, b, n);

    CalcArrayVals_cpp(c1, a, b, n);
    CalcArrayVals_a(c2, a, b, n);

    DisplayResults(c1, c2, a, b, n);
    return 0;
}
