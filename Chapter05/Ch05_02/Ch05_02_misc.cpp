//-----------------------------------------------------------------------------
// Ch05_02_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch05_02.h"

void DisplayResults(size_t i, float r, float h, float vol1, float sa1, float vol2, float sa2)
{
    constexpr int w1 = 4;
    constexpr int w2 = 8;
    constexpr char sp = ' ';

    std::cout << "i: " << i << sp;
    std::cout << "r: " << std::setw(w1) << r << sp;
    std::cout << "h: " << std::setw(w1) << h << sp;
    std::cout << "vol1: " << std::setw(w2) << vol1 << sp;
    std::cout << "vol2: " << std::setw(w2) << vol2 << sp;
    std::cout << "sa1: " << std::setw(w2) << sa1 << sp;
    std::cout << "sa2: " << std::setw(w2) << sa2 << '\n';
}
