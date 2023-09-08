//-----------------------------------------------------------------------------
// Ch02_04_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch02_04.h"

void DisplayResults(const char* msg, long long a, long long b, long long c,
    long long d, long long r1, long long r2)
{
    constexpr char nl = '\n';

    std::cout << msg << nl;
    std::cout << "a =  " << a << nl;
    std::cout << "b =  " << b << nl;
    std::cout << "c =  " << c << nl;
    std::cout << "d =  " << d << nl;
    std::cout << "r1 = " << r1 << nl;
    std::cout << "r2 = " << r2 << nl;
    std::cout << nl;
}
