//-----------------------------------------------------------------------------
// Ch16_04.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch16_04.h"

void VecCrossProducts()
{
    VecSOA a, b;
    VecSOA c1, c2, c3;
    constexpr char nl = '\n';
    constexpr size_t num_vec = c_NumVec;

    AllocateTestVectors(&c1, &c2, &c3, &a, &b, num_vec);

    bool rc1 = VecCrossProducts_cpp(&c1, &a, &b);
    bool rc2 = VecCrossProducts_avx2(&c2, &a, &b);
    bool rc3 = VecCrossProductsNT_avx2(&c3, &a, &b);

    std::cout << "----- Results for Ch16_04 -----\n";

    if (rc1 && rc2 && rc3)
        DisplayResults(&c1, &c2, &c3, &a, &b);
    else
    {
        std::cout << "Invalid return code\n";
        std::cout << "rc1: " << std::boolalpha << rc1 << nl;
        std::cout << "rc2: " << std::boolalpha << rc2 << nl;
        std::cout << "rc3: " << std::boolalpha << rc3 << nl;
    }

    ReleaseTestVectors(&c1, &c2, &c3, &a, &b);
}

int main(void)
{
    try
    {
        VecCrossProducts();
        VecCrossProducts_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch16_04 exception: " << ex.what() << '\n';
    }

    return 0;
}
