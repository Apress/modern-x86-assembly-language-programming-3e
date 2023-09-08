//-----------------------------------------------------------------------------
// Ch07_01.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <string>
#include "Ch07_01.h"

int main()
{
    constexpr size_t n = 19;
    float x[n], y[n], z1[n], z2[n];

    // Initialize the data arrays
    for (size_t i = 0; i < n; i++)
    {
        x[i] = i * 10.0f + 10.0f;
        y[i] = i * 1000.0f + 1000.0f;
        z1[i] = z2[i] = 0.0f;
    }

    // Exercise the calculating functions
    CalcZ_cpp(z1, x, y, n);
    CalcZ_avx(z2, x, y, n);

    // Display the results
    constexpr char nl = '\n';
    constexpr size_t w = 10;
    std::cout << std::fixed << std::setprecision(1);

    std::cout << "----- Results for Ch07_01 -----\n\n";

    std::cout << std::setw(w) << "i";
    std::cout << std::setw(w) << "x";
    std::cout << std::setw(w) << "y";
    std::cout << std::setw(w) << "z1";
    std::cout << std::setw(w) << "z2" << nl;
    std::cout << std::string(52, '-') << nl;

    for (size_t i = 0; i < n; i++)
    {
        std::cout << std::setw(w) << i;
        std::cout << std::setw(w) << x[i];
        std::cout << std::setw(w) << y[i];
        std::cout << std::setw(w) << z1[i];
        std::cout << std::setw(w) << z2[i];

        if (z1[i] != z2[i])
            std::cout << " - Compare error";
        std::cout << nl;
    }
}
