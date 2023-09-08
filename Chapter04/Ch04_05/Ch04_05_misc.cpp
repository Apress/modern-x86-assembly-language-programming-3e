//-----------------------------------------------------------------------------
// Ch04_05_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <cstring>
#include "Ch04_05.h"
#include "MT.h"

void InitArrays(int32_t* x, int32_t* y, int64_t n, unsigned int rng_seed)
{
    constexpr int min_val = 1;
    constexpr int max_val = 10000;

    MT::FillArray(x, n, min_val, max_val, rng_seed, true);
    memcpy(y, x, sizeof(int32_t) * n);
}

void DisplayResult(const char* msg, int64_t expected, int64_t result1, int64_t result2)
{
    std::cout << msg << " (index = " << expected << ")\n";

    std::cout << "  result1 = " << result1;
    std::cout << "  result2 = " << result2 << '\n';

    if (expected != result1 || expected != result2)
        std::cout << "  compare test failed\n";

    std::cout << '\n';    
}
