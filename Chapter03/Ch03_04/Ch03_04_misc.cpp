//-----------------------------------------------------------------------------
// Ch03_04_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch03_04.h"

void DisplayResults(const char* s1, int32_t a, int32_t b, int32_t c,
    int32_t result)
{
    constexpr int w = 4;

    std::cout << s1 << "(";
    std::cout << std::setw(w) << a << ", ";
    std::cout << std::setw(w) << b << ", ";
    std::cout << std::setw(w) << c << ") = ";
    std::cout << std::setw(w) << result << '\n';
}
