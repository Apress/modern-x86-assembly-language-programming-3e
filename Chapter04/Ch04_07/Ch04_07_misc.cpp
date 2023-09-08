//-----------------------------------------------------------------------------
// Ch04_07_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <cstring>
#include "Ch04_07.h"
#include "MT.h"

void InitArrays(int32_t* y, int32_t* x, int32_t n)
{
    constexpr int max_val = 1000;
    constexpr int min_val = -max_val;
    constexpr unsigned int rng_seed = 17;

    MT::FillArray(x, n, min_val, max_val, rng_seed, true);
    memset(y, 0, sizeof(int32_t) * n);
}

void DisplayResults(const int32_t* y, const int32_t* x, int32_t n, int rc)
{
    if (rc != 0)
    {
        std::cout << "\n----- Results for Ch04_07 -----\n";

        constexpr int w = 5;

        for (int i = 0; i < n; i++)
        {
            std::cout << "  i: " << std::setw(w) << i;
            std::cout << "  y: " << std::setw(w) << y[i];
            std::cout << "  x: " << std::setw(w) << x[i] << '\n';

            if (x[i] != y[n - 1 - i])
            {
                std::cout << "ReverseArrayI32_a() element compare error\n";
                break;
            }
        }
    }
    else
        std::cout << "ReverseArrayI32_a() failed\n";
}
