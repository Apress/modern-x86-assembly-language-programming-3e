//-----------------------------------------------------------------------------
// Ch02_05.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch02_05.h"

int main()
{
    constexpr int a_vals[] {47, -291, 19, 247 };
    constexpr int b_vals[] {13, 7, 0, 85 };
    constexpr int n = sizeof(a_vals) / sizeof(int);

    std::cout << "----- Results for Ch02_05 -----\n\n";

    for (int i = 0; i < n; i++)
    {
        int a = a_vals[i];
        int b = b_vals[i];
        int prod1, quo, rem;
        long long prod2;

        MulI32_a(&prod1, &prod2, a, b);
        int rc = DivI32_a(&quo, &rem, a, b);
        DisplayResults(i, a, b, prod1, prod2, quo, rem, rc);
    }

    return 0;
}
