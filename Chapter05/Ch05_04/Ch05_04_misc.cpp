//-----------------------------------------------------------------------------
// Ch05_04_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch05_04.h"

static const char* c_OpStrings[c_NumCmpOps] =
{
    "UO", "LT", "LE", "EQ", "NE", "GT", "GE"
};

void DisplayResults(const uint8_t* cmp_results, float a, float b)
{
    constexpr char nl = '\n';

    std::cout << std::fixed << std::setprecision(1);
    std::cout << "a = " << a << ", b = " << b << nl;

    for (size_t i = 0; i < c_NumCmpOps; i++)
    {
        std::cout << c_OpStrings[i] << '=';
        std::cout << std::boolalpha << std::left;
        std::cout << std::setw(6) << (cmp_results[i] != 0) << ' ';
    }

    std::cout << nl << nl;
}
