//-----------------------------------------------------------------------------
// Ch04_01.cpp
//-----------------------------------------------------------------------------

#include "Ch04_01.h"

int main(void)
{
    constexpr size_t n = 20;
    int32_t x[n];

    FillArray(x, n);

    int64_t sum1 = SumElementsI32_cpp(x, n);
    int64_t sum2 = SumElementsI32_a(x, n);

    DisplayResults(x, n, sum1, sum2);
    return 0;
}