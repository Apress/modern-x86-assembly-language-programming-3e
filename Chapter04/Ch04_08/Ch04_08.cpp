//-----------------------------------------------------------------------------
// Ch04_08.cpp
//-----------------------------------------------------------------------------

#include "Ch04_08.h"

int main()
{
    TestStruct ts;

    ts.Val8 = -100;
    ts.Val16 = 2000;
    ts.Val32 = -300000;
    ts.Val64 = 40000000000;

    int64_t sum1 = ts.Val8 + ts.Val16 + ts.Val32 + ts.Val64;
    int64_t sum2 = SumStructVals_a(&ts);

    DisplayResults(ts, sum1, sum2);
    return 0;
}
