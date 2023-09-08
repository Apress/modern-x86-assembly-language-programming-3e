//-----------------------------------------------------------------------------
// Ch03_05.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch03_05.h"

constexpr int64_t c_ValMax = 77935;
int64_t g_ValMax = c_ValMax;        

int main(void)
{
    constexpr int64_t n_vals[] { 3, 4, 21, 0,
        c_ValMax, c_ValMax + 1, 100, -42, };

    constexpr int64_t num_n_vals = sizeof(n_vals) / sizeof(int64_t);

    std::cout << "----- Results for Ch03_05 -----\n";

    for (int i = 0; i < num_n_vals; i++)
    {
        int64_t sum1, sum2;
        int64_t n = n_vals[i];

        bool rc1 = CalcSumCubes_cpp(&sum1, n);
        bool rc2 = CalcSumCubes_a(&sum2, n);

        DisplayResults(i, n, sum1, rc1, sum2, rc2);
    }

    return 0;
}
