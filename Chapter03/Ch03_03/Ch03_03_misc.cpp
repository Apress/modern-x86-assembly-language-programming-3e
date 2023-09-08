//-----------------------------------------------------------------------------
// Ch03_03_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch03_03.h"

void DisplayResults(int32_t i, int32_t rc, int32_t v1, int32_t v2,
    int32_t v3, int32_t v4)
{
    constexpr int w = 5;
    constexpr char nl = '\n';
    const char* delim = ", ";

    std::cout << "i  = " << std::setw(w - 1) << i << delim;
    std::cout << "rc = " << std::setw(w - 1) << rc << delim;
    std::cout << "v1 = " << std::setw(w) << v1 << delim;
    std::cout << "v2 = " << std::setw(w) << v2 << delim;
    std::cout << "v3 = " << std::setw(w) << v3 << delim;
    std::cout << "v4 = " << std::setw(w) << v4 << nl;

    if (!(v1 == v2 && v2 == v3 && v3 == v4))
        std::cout << "validation test failed, i = " << i << nl;
}
