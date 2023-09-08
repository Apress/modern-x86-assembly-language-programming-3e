//-----------------------------------------------------------------------------
// Ch05_05_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch05_05.h"

static const char* c_OpStrings[c_NumCmpOps] =
{
    "cmp_eq ", "cmp_ne ", "cmp_lt ", "cmp_le ",
    "cmp_gt ", "cmp_ge ", "cmp_ord", "cmp_uno"
};

void DisplayResults(const uint8_t* cmp_results, float a, float b)
{
    constexpr char nl = '\n';

    std::cout << std::fixed << std::setprecision(1);
    std::cout << "a = " << a << nl;
    std::cout << "b = " << b << nl;

    for (size_t i = 0; i < c_NumCmpOps; i++)
    {
        if (i != 0 && (i % 4) == 0)
            std::cout << nl;

        std::cout << c_OpStrings[i] << " = ";
        std::cout << std::boolalpha << std::left;
        std::cout << std::setw(6) << (cmp_results[i] != 0) << ' ';

    }

    std::cout << nl << nl;
}
