//-----------------------------------------------------------------------------
// Ch03_02_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch03_02.h"

void DisplayResults(int8_t a, int16_t b, int32_t c, int64_t d,
    int8_t e, int16_t f, int32_t g, int64_t h, int64_t prod1, int64_t prod2)
{
    constexpr char nl = '\n';

    std::cout << "\nCalcResultI64 results\n";
    std::cout << "a = " << (int)a << ", b = " << b << ", c = " << c;
    std::cout << ", d = " << d << ", e = " << (int)e << ", f = " << f;
    std::cout << ", g = " << g << ", h = " << h << nl;
    std::cout << "prod1 = " << prod1 << nl;
    std::cout << "prod2 = " << prod2 << nl;
}

void DisplayResults(uint8_t a, uint16_t b, uint32_t c, uint64_t d,
    uint8_t e, uint16_t f, uint32_t g, uint64_t h,
    uint64_t quo1, uint64_t rem1, uint64_t quo2, uint64_t rem2)
{
    constexpr char nl = '\n';

    std::cout << "\nCalcResultU64 results\n";
    std::cout << "a = " << (unsigned)a << ", b = " << b << ", c = " << c;
    std::cout << ", d = " << d << ", e = " << (unsigned)e << ", f = " << f;
    std::cout << ", g = " << g << ", h = " << h << nl;
    std::cout << "quo1 = " << quo1 << ", rem1 = " << rem1 << nl;
    std::cout << "quo2 = " << quo2 << ", rem2 = " << rem2 << nl;
}
