//-----------------------------------------------------------------------------
// Ch04_04_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch04_04.h"

void DisplayResults(char sea_char, size_t n1, size_t n2)
{
    constexpr char nl = '\n';

    std::cout << "Search char: " << sea_char << " | ";
    std::cout << "Character counts: n1 = " << n1 << ", n2 = " << n2 << nl;

    if (n1 != n2)
        std::cout << "compare check failed!\n";
}
