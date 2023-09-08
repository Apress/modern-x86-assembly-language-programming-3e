//-----------------------------------------------------------------------------
// Ch06_01.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch06_01.h"

int main()
{
    int8_t a = 10, e = -20;
    int16_t b = -200, f = 400;
    int32_t c = -300, g = -600;
    int64_t d = 4000, h = -8000;

    int64_t sum1 = a + b + c + d + e + f + g + h;
    int64_t sum2 = SumIntegers_a(a, b, c, d, e, f, g, h);

    constexpr int w = 7;
    constexpr char nl = '\n';

    std::cout << "----- Results for Ch06_01 -----\n";
    std::cout << "a:    " << std::setw(w) << (int)a << nl;
    std::cout << "b:    " << std::setw(w) << b << nl;
    std::cout << "c:    " << std::setw(w) << c << nl;
    std::cout << "d:    " << std::setw(w) << d << nl;
    std::cout << "e:    " << std::setw(w) << (int)e << nl;
    std::cout << "f:    " << std::setw(w) << f << nl;
    std::cout << "g:    " << std::setw(w) << g << nl;
    std::cout << "h:    " << std::setw(w) << h << nl;
    std::cout << "sum1: " << std::setw(w) << sum1 << nl;
    std::cout << "sum2: " << std::setw(w) << sum2 << nl;

    std::cout << "\nsum1/sum2 compare check ";

    if (sum1 == sum2)
        std::cout << "passed\n";
    else
        std::cout << "failed!\n";

    return 0;
}
