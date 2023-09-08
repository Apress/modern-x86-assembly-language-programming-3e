//-----------------------------------------------------------------------------
// Ch17_01.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <cmath>
#include "Ch17_01.h"
#include <AlignedMem.h>

static void CalcResult(void)
{
    constexpr size_t n = c_ArraySize;
    constexpr size_t align = c_Alignment;

    AlignedArray<double> x_aa(n, align);
    AlignedArray<double> y1_aa(n, align);
    AlignedArray<double> y2_aa(n, align);

    double* x = x_aa.Data();
    double* y1 = y1_aa.Data();
    double* y2 = y2_aa.Data();

    for (size_t i = 0; i < n; i++)
        x[i] = (double)i;

    bool rc1 = CalcResult_cpp(y1, x, n);
    bool rc2 = CalcResult_avx(y2, x, n);

    std::cout << "----- Results for Ch17_01 -----\n\n";

    if (rc1 == rc2)
    {
        size_t num_diff = 0;
        constexpr double eps = 1.0e-12;

        for (size_t i = 0; i < n; i++)
        {
            if (fabs(y1[i] - y2[i]) > eps)
            {
                std::cout << "Compare error at index " << i << '\n';
                num_diff++;
            }
        }

        if (num_diff == 0)
            std::cout << "Compare test passed\n";
        else
            std::cout << "Compare test failed!\n";
    }
    else
        std::cout << "Invalid return code\n";
}

int main(void)
{
    try
    {
        CalcResult();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch17_01 exception: " << ex.what() << '\n';
    }

    return 0;
}
