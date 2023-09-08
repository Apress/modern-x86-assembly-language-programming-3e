//-----------------------------------------------------------------------------
// Ch11_01.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch11_01.h"
#include "AlignedMem.h"

static void CalcLeastSquares(void)
{
    constexpr size_t n = 59;

    AlignedArray<double> x_aa(n, c_Alignment);
    AlignedArray<double> y_aa(n, c_Alignment);

    double* x = x_aa.Data();
    double* y = y_aa.Data();

    InitArrays(x, y, n);

    double m1, m2;
    double b1, b2;
    CalcLeastSquares_cpp(&m1, &b1, x, y, n, c_LsEpsilon);
    CalcLeastSquares_avx2(&m2, &b2, x, y, n, c_LsEpsilon);

    constexpr int w = 12;
    constexpr char nl = '\n';
    std::cout << std::fixed << std::setprecision(8);

    std::cout << "\n----- Results for Ch11_01 -----\n";
    std::cout << "slope m1:      " << std::setw(w) << m1 << nl;
    std::cout << "intercept b1:  " << std::setw(w) << b1 << nl;
    std::cout << "slope m2:      " << std::setw(w) << m2 << nl;
    std::cout << "intercept b2:  " << std::setw(w) << b2 << nl;
}

int main(void)
{
    try
    {
        CalcLeastSquares();
        CalcLeastSquares_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch11_01 exception: " << ex.what() << '\n';
    }

    return 0;
}
