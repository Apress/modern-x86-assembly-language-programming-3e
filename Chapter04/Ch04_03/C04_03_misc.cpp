//-----------------------------------------------------------------------------
// Ch04_03_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch04_03.h"

void DisplayResults(const int32_t* y1, const int32_t* y2, const int32_t* x,
    size_t m, size_t n)
{
    std::cout << "----- Results for Ch04_03 -----\n";

    for (size_t i = 0; i < m; i++)
    {
        for (size_t j = 0; j < n; j++)
        {
            size_t kx = j * m + i;
            size_t ky = i * n + j;

            std::cout << "x[" << std::setw(2) << j << "][" << std::setw(2) << i << "] = ";
            std::cout << std::setw(6) << x[kx] << "   ";

            std::cout << "y1[" << std::setw(2) << i << "][" << std::setw(2) << j << "] = ";
            std::cout << std::setw(6) << y1[ky] << "   ";

            std::cout << "y2[" << std::setw(2) << i << "][" << std::setw(2) << j << "] = ";
            std::cout << std::setw(6) << y2[ky] << '\n';

            if (y1[ky] != y2[ky])
            {
                std::cout << "\nmatrix element compare failed\n";
                break;
            }
        }
    }
}
