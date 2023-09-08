//-----------------------------------------------------------------------------
// Ch09_06_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch09_06.h"
#include "MT.h"

void DisplayResults(std::vector<double>& col_means1,
    std::vector<double>& col_means2, std::vector<double>& x, size_t nrows,
    size_t ncols)
{
    constexpr int w = 5;
    constexpr char nl = '\n';

    std::cout << std::fixed << std::setprecision(1);
    std::cout << "----- Results for Ch09_06 -----\n";

    for (size_t i = 0; i < nrows; i++)
    {
        for (size_t j = 0; j < ncols; j++)
            std::cout << std::setw(w) << x[i * ncols + j] << " ";
        std::cout << nl;
    }

    std::cout << nl;

    for (size_t j = 0; j < ncols; j++)
        std::cout << std::setw(w) << col_means1[j] << " ";
    std::cout << nl;

    for (size_t j = 0; j < ncols; j++)
        std::cout << std::setw(w) << col_means2[j] << " ";
    std::cout << nl;

    if (!MT::CompareVectorsFP(col_means1, col_means2, 1.0e-6))
        std::cout << "MT::CompareVectorsFP() failed\n";
}

void InitMatrix(std::vector<double>& x, size_t nrows, size_t ncols)
{
    MT::FillMatrixFP(x.data(), nrows, ncols, c_MatrixFillMin, c_MatrixFillMax, c_RngSeed);
}
