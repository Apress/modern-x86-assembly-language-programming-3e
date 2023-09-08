//-----------------------------------------------------------------------------
// Ch14_03_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <string>
#include <cmath>
#include <random>
#include "Ch14_03.h"
#include "AlignedMem.h"

bool CheckArgs(const double* d, const double* x1, const double* y1,
    const double* x2, const double* y2, size_t n)
{
    if (n == 0 || (n % 8) != 0)
        return false;

    if (!AlignedMem::IsAligned(d, c_Alignment))
        return false;

    if (!AlignedMem::IsAligned(x1, c_Alignment))
        return false;

    if (!AlignedMem::IsAligned(y1, c_Alignment))
        return false;

    if (!AlignedMem::IsAligned(x2, c_Alignment))
        return false;

    if (!AlignedMem::IsAligned(y2, c_Alignment))
        return false;

    return true;
}

void DisplayResults(const double* d1, const double* d2, const double* x1,
    const double* y1, const double* x2, const double* y2, size_t n, double thresh)
{
    constexpr int w = 9;
    constexpr char nl = '\n';

    std::cout << std::fixed << std::setprecision(4);
    std::cout << "----- Results for Ch14_03 (thresh = " << thresh;
    std::cout << ") -----\n\n";

    std::cout << std::setw(w) << "x1" << " ";
    std::cout << std::setw(w) << "y1" << " ";
    std::cout << std::setw(w) << "x2" << " ";
    std::cout << std::setw(w) << "y2" << " |";
    std::cout << std::setw(w) << "d1" << " ";
    std::cout << std::setw(w) << "d2" << nl;
    std::cout << std::string(60, '-') << nl;

    for (size_t i = 0; i < n; i++)
    {
        std::cout << std::setw(w) << x1[i] << " ";
        std::cout << std::setw(w) << y1[i] << " ";
        std::cout << std::setw(w) << x2[i] << " ";
        std::cout << std::setw(w) << y2[i] << " |";
        std::cout << std::setw(w) << d1[i] << " ";
        std::cout << std::setw(w) << d2[i] << nl;

        if (fabs(d1[i] - d2[i]) > 1.0e-9)
        {
            std::cout << "compare check failed\n";
            break;
        }
    }
}

void InitArrays(double* x1, double* y1, double* x2, double* y2, size_t n)
{
    constexpr unsigned int rng_seed = 39;
    constexpr double min_val = 1.0;
    constexpr double max_val = 75.0;

    std::mt19937 rng {rng_seed};
    std::uniform_real_distribution<double> dist {min_val, max_val};

    for (size_t i = 0; i < n; i++)
    {
        x1[i] = dist(rng);
        y1[i] = dist(rng);
        x2[i] = dist(rng);
        y2[i] = dist(rng);
    }
}
