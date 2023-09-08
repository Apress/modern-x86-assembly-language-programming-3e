//------------------------------------------------------------------------------
// Example1.cpp
//------------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <string>
#include <cmath>

extern "C" void CalcZ_avx(float* z, const float* x, const float* y, size_t n);

static void CalcZ_cpp(float* z, const float* x, const float* y, size_t n)
{
    for (size_t i = 0; i < n; i++)
        z[i] = x[i] + y[i];
}

int main(void)
{
    constexpr size_t n = 20;
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
    constexpr float eps = 1.0e-6f;

    std::cout << std::fixed << std::setprecision(1);

    std::cout << std::setw(w) << "i";
    std::cout << std::setw(w) << "x";
    std::cout << std::setw(w) << "y";
    std::cout << std::setw(w) << "z1";
    std::cout << std::setw(w) << "z2" << nl;
    std::cout << std::string(50, '-') << nl;

    for (size_t i = 0; i < n; i++)
    {
        std::cout << std::setw(w) << i;
        std::cout << std::setw(w) << x[i];
        std::cout << std::setw(w) << y[i];
        std::cout << std::setw(w) << z1[i];
        std::cout << std::setw(w) << z2[i] << nl;

        if (fabs(z1[i] - z2[i]) > eps)
        {
            std::cout << "Compare error!\n";
            break;
        }
    }
}
