//-----------------------------------------------------------------------------
// Ch04_06.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <cstdint>
#include "Ch04_06.h"

static void CopyArray(void)
{
    constexpr size_t n = 10;
    constexpr int32_t a[n] = { 10, -20, 30, 40, -50, 60, 70, -80, 90, 10 };
    int32_t b[n] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

    CopyArrayI32_a(b, a, n);

    std::cout << "\nCopyArrayI32_a() results:\n";

    for (size_t i = 0; i < n; i++)
    {
        std::cout << std::setw(5) << i << ": ";
        std::cout << std::setw(5) << a[i] << " ";
        std::cout << std::setw(5) << b[i] << '\n';
    }
}

static void FillArray(void)
{
    constexpr int64_t fill_val = -7;
    constexpr size_t n = 10;

    int64_t a[n] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    FillArrayI64_a(a, fill_val, n);

    std::cout << "\nFillArrayI32_a() results:\n";

    for (size_t i = 0; i < n; i++)
    {
        std::cout << std::setw(5) << i << ": ";
        std::cout << std::setw(5) << a[i] << '\n';
    }
}

int main(void)
{
    std::cout << "----- Results for Ch04_06 -----\n";

    CopyArray();
    FillArray();
    return 0;
}
