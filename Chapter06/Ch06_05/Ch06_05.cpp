//-----------------------------------------------------------------------------
// Ch06_05.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch06_05.h"

int main()
{
    int8_t a = 10, e = -51;
    int16_t b = -21, f = 68;
    int32_t c = -37, g = -73;
    int64_t d = 49, h = -82;

    int64_t prod1 = MulIntegers_cpp(a, b, c, d, e, f, g, h);
    int64_t prod2 = MulIntegers_a(a, b, c, d, e, f, g, h);

    constexpr  int w = 14;
    constexpr char nl = '\n';

    std::cout << "----- Results for Ch06_05 -----\n";
    std::cout << "a:     " << std::setw(w) << (int)a << nl;
    std::cout << "b:     " << std::setw(w) << b << nl;
    std::cout << "c:     " << std::setw(w) << c << nl;
    std::cout << "d:     " << std::setw(w) << d << nl;
    std::cout << "e:     " << std::setw(w) << (int)e << nl;
    std::cout << "f:     " << std::setw(w) << f << nl;
    std::cout << "g:     " << std::setw(w) << g << nl;
    std::cout << "h:     " << std::setw(w) << h << nl;
    std::cout << "prod1: " << std::setw(w) << prod1 << nl;
    std::cout << "prod2: " << std::setw(w) << prod2 << nl;

    return 0;
}
