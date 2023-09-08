//-----------------------------------------------------------------------------
// Ch03_02.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch03_02.h"

static void CalcResultI64(void)
{
    int8_t a = 2, e = 3;
    int16_t b = -3, f = -7;;
    int32_t c = 8, g = -5;
    int64_t d = 4, h = 10;

    // Calculate (a * b * c * d) + (e * f * g * h)
    int64_t prod1 = ((int64_t)a * b * c * d) + ((int64_t)e * f * g * h);
    int64_t prod2 = CalcResultI64_a(a, b, c, d, e, f, g, h);

    DisplayResults(a, b, c, d, e, f, g, h, prod1, prod2);
}

static void CalcResultU64(void)
{
    uint8_t a = 12, e = 101;
    uint16_t b = 17, f = 37;
    uint32_t c = 71000000, g =25;
    uint64_t d = 90000000000, h = 5;

    uint64_t quo1, rem1;
    uint64_t quo2, rem2;

    // Calculate quotient and remainder for (a + b + c + d) / (e + f + g + h)
    quo1 = ((uint64_t)a + b + c + d) / ((uint64_t)e + f + g + h);
    rem1 = ((uint64_t)a + b + c + d) % ((uint64_t)e + f + g + h);
    CalcResultU64_a(a, b, c, d, e, f, g, h, &quo2, &rem2);

    DisplayResults(a, b, c, d, e, f, g, h, quo1, rem1, quo2, rem2);
}

int main()
{
    std::cout << "----- Results for Ch03_02 -----\n";

    CalcResultI64();
    CalcResultU64();
    return 0;
}
