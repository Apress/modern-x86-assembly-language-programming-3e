//-----------------------------------------------------------------------------
// Ch05_03_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch05_03.h"

extern void DisplayResults(size_t i, double r, double vol1, double sa1,
    double vol2, double sa2)
{
    constexpr int w1 = 6;
    constexpr int w2 = 9;
    constexpr char sp = ' ';

    std::cout << "i: " << i << sp;
    std::cout << "r: " << std::setw(w1) << r << sp;
    std::cout << "vol1: " << std::setw(w2) << vol1 << sp;
    std::cout << "vol2: " << std::setw(w2) << vol2 << sp;
    std::cout << "sa1: " << std::setw(w2) << sa1 << sp;
    std::cout << "sa2: " << std::setw(w2) << sa2 << '\n';
}
