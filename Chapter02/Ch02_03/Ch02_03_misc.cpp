//-----------------------------------------------------------------------------
// Ch02_03_misc.cpp
//-----------------------------------------------------------------------------

#include "Ch02_03.h"
#include <iostream>
#include <iomanip>
#include <bitset>

void DisplayResults(const char* s, int rc, unsigned int a, unsigned int count,
    unsigned int a_shl, unsigned int a_shr)
{
    constexpr int w = 10;
    constexpr char nl = '\n';

    std::bitset<32> a_bs(a);
    std::bitset<32> a_shl_bs(a_shl);
    std::bitset<32> a_shr_bs(a_shr);

    std::cout << s << nl;
    std::cout << "count: " << std::setw(w) << count << nl;
    std::cout << "a:     " << std::setw(w) << a << " (0b" << a_bs << ")" << nl;

    if (rc == 1)
    {
        std::cout << "shl:   " << std::setw(w) << a_shl;
        std::cout << " (0b" << a_shl_bs << ")" << nl;
        std::cout << "shr:   " << std::setw(w) << a_shr;
        std::cout << " (0b" << a_shr_bs << ")" << nl;
    }
    else
        std::cout << "Invalid shift count" << nl;

    std::cout << nl;
}
