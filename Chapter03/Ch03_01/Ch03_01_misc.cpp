//-----------------------------------------------------------------------------
// Ch03_01_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch03_01.h"

void DisplayResults(int32_t a, int32_t b, int32_t c, int32_t d,
    int32_t e, int32_t f, int32_t g, int32_t h, int32_t result1, int32_t result2)
{
    constexpr char nl = '\n';

    std::cout << "\nStack Example #1\n";
    std::cout << "a = " << a << ", b = " << b << ", c = " << c << ' ';
    std::cout << "d = " << d << ", e = " << e << ", f = " << f << ' ';
    std::cout << "g = " << g << ", h = " << h << nl;
    std::cout << "result1 = " << result1 << ", result2 = " << result2 << nl;
}

void DisplayResults(uint64_t a, uint64_t b, uint64_t c, uint64_t d, uint64_t e,
    uint64_t f, uint64_t g, uint64_t h, uint64_t result1, uint64_t result2)
{
    constexpr char nl = '\n';

    std::cout << "\nStack Example #2\n";
    std::cout << "a = " << a << ", b = " << b << ", c = " << c << ' ';
    std::cout << "d = " << d << ", e = " << e << ", f = " << f << ' ';
    std::cout << "g = " << g << ", h = " << h << nl;
    std::cout << "result1 = " << result1 << ", result2 = " << result2 << nl;
}
