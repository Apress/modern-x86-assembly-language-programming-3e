//-----------------------------------------------------------------------------
// Ch02_02_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch02_02.h"

void DisplayResults(unsigned int a, unsigned int b, unsigned int c,
    unsigned int d, unsigned int r1, unsigned int r2)
{
    constexpr int w = 8;
    constexpr char nl = '\n';

    std::cout << "----- Results for Ch02_02 -----\n";

    std::cout << std::setfill('0');
    std::cout << "a =  0x" << std::hex << std::setw(w) << a << nl;
    std::cout << "b =  0x" << std::hex << std::setw(w) << b << nl;
    std::cout << "c =  0x" << std::hex << std::setw(w) << c << nl;
    std::cout << "d =  0x" << std::hex << std::setw(w) << d << nl;
    std::cout << "r1 = 0x" << std::hex << std::setw(w) << r1 << nl;
    std::cout << "r2 = 0x" << std::hex << std::setw(w) << r2 << nl;
    std::cout << nl;

    if (r1 != r2)
        std::cout << "Compare check failed" << nl;
}
