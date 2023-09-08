//-----------------------------------------------------------------------------
// Ch05_02.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch05_02.h"

int main()
{
    constexpr float r_vals[] { 1.0f, 2.0f, 3.0f, 4.0f, 5.0f };
    constexpr float h_vals[] { 1.0f, 3.5f, 4.0f, 6.5f, 8.0f };
    constexpr size_t n = sizeof(r_vals) / sizeof(float);

    std::cout << "----- Results for Ch05_02 -----\n";
    std::cout << std::fixed << std::setprecision(3);

    for (size_t i = 0; i < n; i++)
    {
        float vol1, sa1;
        float vol2, sa2;
        float r = r_vals[i];
        float h = h_vals[i];

        CalcConeVolSA_cpp(&vol1, &sa1, r, h);
        CalcConeVolSA_avx(&vol2, &sa2, r, h);
        DisplayResults(i, r, h, vol1, sa1, vol2, sa2);
    }

    return 0;
}
