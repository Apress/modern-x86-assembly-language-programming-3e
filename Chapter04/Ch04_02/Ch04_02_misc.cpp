//-----------------------------------------------------------------------------
// Ch04_02_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <cstring>
#include "Ch04_02.h"
#include "MT.h"

void FillArrays(int64_t* c1, int64_t* c2, int64_t* a, int64_t* b, size_t n)
{
    constexpr int max_val = 1000;
    constexpr int min_val = -max_val;
    constexpr unsigned int rng_seed = 1001;

    MT::FillArray(a, n, min_val, max_val, rng_seed, true);
    MT::FillArray(b, n, min_val, max_val, rng_seed / 7, true);

    memset(c1, 0, sizeof(int64_t) * n);
    memset(c2, 0, sizeof(int64_t) * n);
}

void DisplayResults(const int64_t* c1, const int64_t* c2, const int64_t* a,
    const int64_t* b, size_t n)
{
    std::cout << "----- Results for Ch04_02 -----\n";

    for (size_t i = 0; i < n; i++)
    {
        std::cout << "a[" << std::setw(2) << i << "]: " << std::setw(8) << a[i];
        std::cout << "  ";
        std::cout << "b[" << std::setw(2) << i << "]: " << std::setw(8) << b[i];
        std::cout << "  ";
        std::cout << "c1[" << std::setw(2) << i << "]: " << std::setw(8) << c1[i];
        std::cout << "  ";
        std::cout << "c2[" << std::setw(2) << i << "]: " << std::setw(8) << c2[i];
        std::cout << '\n';

        if (c1[i] != c2[i])
        {
            std::cout << "array element compare failed\n";
            break;
        }
    }
}
