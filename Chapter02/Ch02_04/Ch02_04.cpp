//-----------------------------------------------------------------------------
// Ch02_04.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch02_04.h"

int main()
{
    long long a = 10;
    long long b = 40;
    long long c = 9;
    long long d = 6;
    long long r1, r2;

    std::cout << "----- Results for Ch02_04 -----\n\n";

    r1 = (a + b) - (c + d) + 7;
    r2 = AddSubI64a_a(a, b, c, d);
    DisplayResults("Results for AddSubI64a_a()", a, b, c, d, r1, r2);

    b *= -10000000000;
    r1 = (a + b) - (c + d) + 12345678900;
    r2 = AddSubI64b_a(a, b, c, d);
    DisplayResults("Results for AddSubI64b_a()", a, b, c, d, r1, r2);

    return 0;
}
