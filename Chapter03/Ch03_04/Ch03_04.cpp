//-----------------------------------------------------------------------------
// Ch03_04.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch03_04.h"

int main(void)
{
    constexpr int32_t a_vals[] { 2,   -3,  17, -47 };
    constexpr int32_t b_vals[] { 15, -22,  37, -16 };
    constexpr int32_t c_vals[] { 8,   28, -11,  -9 };
    constexpr int n = sizeof(a_vals) / sizeof(int32_t);

    std::cout << "----- Results for Ch03_04 -----\n";

    for (int i = 0; i < n; i++)
    {
        int32_t a = a_vals[i], b = b_vals[i], c = c_vals[i];

        int32_t smin1 = SignedMin1_a(a, b, c);
        int32_t smin2 = SignedMin2_a(a, b, c);
        int32_t smax1 = SignedMax1_a(a, b, c);
        int32_t smax2 = SignedMax2_a(a, b, c);

        std::cout << "\n------------- Example #" << i + 1 << " -------------\n";
        DisplayResults("SignedMin1_a", a, b, c, smin1);
        DisplayResults("SignedMin2_a", a, b, c, smin2);
        DisplayResults("SignedMax1_a", a, b, c, smax1);
        DisplayResults("SignedMax2_a", a, b, c, smax2);
    }

    return 0;
}
