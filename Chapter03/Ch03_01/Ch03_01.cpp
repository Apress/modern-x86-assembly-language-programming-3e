//-----------------------------------------------------------------------------
// Ch03_01.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch03_01.h"

static void StackExample1(void)
{
    // Stack example #1 - 32-bit integers
    int32_t a = 2, b = -3, c = 8, d = 9;
    int32_t e = 3, f = -7, g = 5, h = -1000000;

    int32_t result1 = a + b + c + d + e + f + g + h;
    int32_t result2 = SumValsI32_a(a, b, c, d, e, f, g, h);

    DisplayResults(a, b, c, d, e, f, g, h, result1, result2);
}

static void StackExample2(void)
{
    // Stack example #2 - 64-bit integers
    uint64_t a = 10, b = 20, c = 30, d = 40;
    uint64_t e = 50, f = 60, g = 70, h = 80;

    uint64_t result1 = a * b * c * d * e * f * g * h;
    uint64_t result2 = MulValsU64_a(a, b, c, d, e, f, g, h);

    DisplayResults(a, b, c, d, e, f, g, h, result1, result2);
}

int main()
{
    std::cout << "----- Results for Ch03_01 ----\n";

    StackExample1();
    StackExample2();
}
