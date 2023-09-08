//-----------------------------------------------------------------------------
// Ch05_03.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch05_03.h"

int main()
{
    constexpr double r_vals[] = { 0.0, 1.0, 2.0, 3.0, 5.0, 10.0, 15.0, 20.0 };
    constexpr size_t n = sizeof(r_vals) / sizeof(double);

    std::cout << "----- Results for Ch05_03 -----\n";
    std::cout << std::fixed << std::setprecision(2);

    for (size_t i = 0; i < n; i++)
    {
        double vol1, sa1;
        double vol2, sa2;

        CalcSphereVolSA_cpp(&vol1, &sa1, r_vals[i]);
        CalcSphereVolSA_avx(&vol2, &sa2, r_vals[i]);
        DisplayResults(i, r_vals[i], vol1, sa1, vol2, sa2);
    }

    return 0;
}
