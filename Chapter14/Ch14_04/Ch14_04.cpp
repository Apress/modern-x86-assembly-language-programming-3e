//-----------------------------------------------------------------------------
// Ch14_04.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch14_04.h"

static void CalcCovMatF64(void)
{
    constexpr size_t n_vars = 12;
    constexpr size_t n_obvs = 103;

    // Initialize test data
    CMD cmd0(n_vars, n_obvs);
    CMD cmd1(n_vars, n_obvs);
    InitCMD(cmd0, cmd1);

    // Calculate covariance matrices
    CalcCovMatF64_cmd0(cmd0);
    CalcCovMatF64_cmd1(cmd1);

    // Display results
    constexpr char nl = '\n';

    std::cout << std::fixed << std::setprecision(2);

    std::cout << "----- Results for Ch14_04 -----\n";
    std::cout << "n_vars = " << n_vars << ", n_obvs = " << n_obvs << nl;

    if (n_vars <= 13)
    {
        std::cout << "Variable means\n";

        for (size_t i = 0; i < n_vars; i++)
        {
            std::cout << std::setw(4) << i << ": ";
            std::cout << std::setw(9) << cmd0.m_VarMeans[i] << " ";
            std::cout << std::setw(9) << cmd1.m_VarMeans[i] << nl;
        }

        std::cout << "\ncmd0.m_CovMat\n" << cmd0.m_CovMat << nl;
        std::cout << "\ncmd1.m_CovMat\n" << cmd1.m_CovMat << nl;
    }

    if (CompareResults(cmd0, cmd1))
        std::cout << "CompareResults - passed\n";
    else
        std::cout << "CompareResults - failed!\n";
}

int main(void)
{
    try
    {
        CalcCovMatF64();
        CalcCovMatF64_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch14_04 exception: " << ex.what() << '\n';
    }

    return 0;
}
