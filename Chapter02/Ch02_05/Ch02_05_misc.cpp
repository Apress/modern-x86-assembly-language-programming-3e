//-----------------------------------------------------------------------------
// Ch02_05_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch02_05.h"

void DisplayResults(int test_id, int a, int b, int prod1,
    long long prod2, int quo, int rem, int rc)
{
    constexpr char nl = '\n';

    std::cout << "Mul/Div test case #" << test_id << nl;
    std::cout << "a = " << a << ", b = " << b << nl;
    std::cout << "prod1 = " << prod1 << ", prod2 = " << prod2 << nl;

    if (rc == 0)
        std::cout << "error: division by zero" << nl;
    else
        std::cout << "quo = " << quo << ", rem = " << rem << nl;

    std::cout << nl;
}
