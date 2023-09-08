//-----------------------------------------------------------------------------
// Ch04_03.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch04_03.h"

int main()
{
    constexpr size_t m = 6;
    constexpr size_t n = 3;
    constexpr int32_t x[n][m]
    {
      { 1, 2, 3, 4, 5, 6 },
      { 7, 8, 9, 10, 11, 12 },
      { 13, 14, 15, 16, 17, 18 }
    };

    int32_t y1[m][n], y2[m][n];

    CalcMat2dSquares_cpp(&y1[0][0], &x[0][0], m, n);
    CalcMat2dSquares_a(&y2[0][0], &x[0][0], m, n);

    DisplayResults(&y1[0][0], &y2[0][0], &x[0][0], m, n);
    return 0;
}
