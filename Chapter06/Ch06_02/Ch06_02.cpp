//-----------------------------------------------------------------------------
// Ch06_02.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch06_02.h"

int main()
{
    constexpr int n = 6;
    constexpr int64_t a[n] = { 2, -2, -6, 7, 12, 5 };
    constexpr int64_t b[n] = { 3, 5, -7, 8, 4, 9 };
    int64_t sum_a, sum_b, prod_a, prod_b;

    CalcSumProd_avx(a, b, n, &sum_a, &sum_b, &prod_a, &prod_b);

    constexpr int w = 6;
    constexpr char nl = '\n';
    const char* sp = "   ";

    std::cout << "----- Results for Ch06_02 -----\n";

    for (int i = 0; i < n; i++)
    {
        std::cout << "i: " << std::setw(w) << i << sp;
        std::cout << "a: " << std::setw(w) << a[i] << sp;
        std::cout << "b: " << std::setw(w) << b[i] << nl;
    }

    std::cout << nl;
    std::cout << "sum_a =  " << std::setw(w) << sum_a << sp;
    std::cout << "sum_b =  " << std::setw(w) << sum_b << nl;
    std::cout << "prod_a = " << std::setw(w) << prod_a << sp;
    std::cout << "prod_b = " << std::setw(w) << prod_b << nl;
}
