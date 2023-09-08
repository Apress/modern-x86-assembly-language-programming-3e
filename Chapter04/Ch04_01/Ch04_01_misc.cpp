//-----------------------------------------------------------------------------
// Ch04_01_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch04_01.h"
#include "MT.h"

void FillArray(int32_t* x, size_t n)
{
    constexpr int max_val = 1000;
    constexpr int min_val = -max_val;
    constexpr unsigned int rng_seed = 1337;

    MT::FillArray(x, n, min_val, max_val, rng_seed, true);
}

void DisplayResults(const int32_t* x, size_t n, int64_t sum1, int64_t sum2)
{
    constexpr char nl = '\n';

    std::cout << "----- Results for Ch04_01 -----\n";

    for (size_t i = 0; i < n; i++)
        std::cout << "x[" << i << "] = " << x[i] << nl;
    std::cout << nl;

    std::cout << "sum1 = " << sum1 << nl;
    std::cout << "sum2 = " << sum2 << nl;
}
