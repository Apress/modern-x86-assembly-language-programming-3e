//-----------------------------------------------------------------------------
// Ch05_04.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <limits>
#include "Ch05_04.h"

int main()
{
    constexpr size_t n = 6;
    float a[n] { 120.0f, 250.0f, 300.0f, -18.0f,  -81.0f, 42.0f };
    float b[n] { 130.0f, 240.0f, 300.0f,  32.0f, -100.0f,  0.0f };

    // Set NAN test value
    b[n - 1] = std::numeric_limits<float>::quiet_NaN();

    std::cout << "\n----- Results for Ch05_04 -----\n";

    for (size_t i = 0; i < n; i++)
    {
        uint8_t cmp_results[c_NumCmpOps];

        CompareF32_avx(cmp_results, a[i], b[i]);
        DisplayResults(cmp_results, a[i], b[i]);
    }
}
