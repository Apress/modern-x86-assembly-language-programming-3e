//-----------------------------------------------------------------------------
// Ch08_05.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch08_05.h"
#include "AlignedMem.h"

static void CalcMinMaxU8()
{
    constexpr char nl = '\n';
    constexpr size_t n = c_NumElements;

    AlignedArray<uint8_t> x_aa(n, 16);
    uint8_t* x = x_aa.Data();

    InitArray(x, n, c_RngSeedVal);

    uint8_t x_min1 = 0, x_max1 = 0;
    uint8_t x_min2 = 0, x_max2 = 0;

    bool rc0 = CalcMinMaxU8_cpp(&x_min1, &x_max1, x, n);
    bool rc1 = CalcMinMaxU8_avx(&x_min2, &x_max2, x, n);

    std::cout << "\nCalcMinMaxU8_cpp() results:\n";
    std::cout << "rc0: " << rc0 << "  x_min1: " << (int)x_min1;
    std::cout << "  x_max1: " << (int)x_max1 << nl;

    std::cout << "\nCalcMinMaxU8_avx() results:\n";
    std::cout << "rc1: " << rc1 << "  x_min2: " << (int)x_min2;
    std::cout << "  x_max2: " << (int)x_max2 << nl;
}

int main(void)
{
    std::cout << "----- Results for Ch08_05 -----\n";

    CalcMinMaxU8();
    return 0;
}
