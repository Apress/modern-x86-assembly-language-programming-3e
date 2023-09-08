//-----------------------------------------------------------------------------
// Ch08_06.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch08_06.h"
#include "AlignedMem.h"

static void CalcMeanU8(void)
{
    constexpr char nl = '\n';
    constexpr uint32_t n = c_NumElements;

    AlignedArray<uint8_t> x_aa(n, c_Alignment);
    uint8_t* x = x_aa.Data();

    InitArray(x, n, c_RngSeedVal);

    bool rc0, rc1;
    uint64_t sum_x0, sum_x1;
    double mean_x0, mean_x1;

    rc0 = CalcMeanU8_cpp(&mean_x0, &sum_x0, x, n);
    rc1 = CalcMeanU8_avx(&mean_x1, &sum_x1, x, n);

    std::cout << std::fixed << std::setprecision(6);

    std::cout << "\nCalcMeanU8_cpp() results:\n";
    std::cout << "rc0:     " << rc0 << nl;
    std::cout << "sum_x0:  " << sum_x0 << nl;
    std::cout << "mean_x0: " << mean_x0 << nl;

    std::cout << "\nCalcMeanU8_avx() results:\n";
    std::cout << "rc1:     " << rc1 << nl;
    std::cout << "sum_x1:  " << sum_x1 << nl;
    std::cout << "mean_x1: " << mean_x1 << nl;
}

int main(void)
{
    std::cout << "----- Results for Ch08_06 -----\n";

    CalcMeanU8();
    return 0;
}
