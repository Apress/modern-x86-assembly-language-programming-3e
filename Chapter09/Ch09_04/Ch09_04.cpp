//-----------------------------------------------------------------------------
// Ch09_04.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch09_04.h"
#include "AlignedMem.h"

static void CalcMeanStDevF64(void)
{
    constexpr size_t n = c_NumElements;
    AlignedArray<double> x_aa(n, c_Alignment);
    double* x = x_aa.Data();

    InitArray(x, n);

    double mean1, mean2, st_dev1, st_dev2;

    bool rc1 = CalcMeanF64_cpp(&mean1, x, n);
    bool rc2 = CalcStDevF64_cpp(&st_dev1, x, n, mean1);
    bool rc3 = CalcMeanF64_avx(&mean2, x, n);
    bool rc4 = CalcStDevF64_avx(&st_dev2, x, n, mean2);

    std::cout << "----- Results for Ch09_04 -----\n";
    std::cout << std::fixed << std::setprecision(6);

    if (rc1 && rc2 && rc3 && rc4)
    {
        constexpr int w = 10;
        constexpr char nl = '\n';

        std::cout << "n:       " << std::setw(w) << n << nl;
        std::cout << "mean1:   " << std::setw(w) << mean1 << "  ";
        std::cout << "st_dev1: " << std::setw(w) << st_dev1 << nl;
        std::cout << "mean2:   " << std::setw(w) << mean2 << "  ";
        std::cout << "st_dev2: " << std::setw(w) << st_dev2 << nl;
    }
    else
        std::cout << "Invalid return code\n";
}

int main(void)
{
    CalcMeanStDevF64();
    return 0;
}
