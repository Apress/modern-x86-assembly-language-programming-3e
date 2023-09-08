//-----------------------------------------------------------------------------
// Ch14_02.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iostream>
#include <iomanip>
#include <limits>
#include <numbers>
#include "Ch14_02.h"

static const char* c_CmpStr[8] = { "EQ", "NE", "LT", "LE", "GT", "GE", "OD", "UO" };

static void CompareF32(void)
{
    using namespace std::numbers;

    ZmmVal a, b;
    uint16_t c[8];
    constexpr char nl = '\n';
    constexpr float qnan_f32 = std::numeric_limits<float>::quiet_NaN();

    a.m_F32[0] = 2.0f;                  b.m_F32[0] = 1.0f;
    a.m_F32[1] = 7.0f;                  b.m_F32[1] = 12.0f;
    a.m_F32[2] = -6.0f;                 b.m_F32[2] = -6.0f;
    a.m_F32[3] = 3.0f;                  b.m_F32[3] = 8.0f;
    a.m_F32[4] = -16.0f;                b.m_F32[4] = -36.0f;
    a.m_F32[5] = 3.5f;                  b.m_F32[5] = 3.5f;
    a.m_F32[6] = (float)pi;             b.m_F32[6] = -6.0f;
    a.m_F32[7] = (float)sqrt2;          b.m_F32[7] = qnan_f32;
    a.m_F32[8] = 102.0f;                b.m_F32[8] = 1.0f / (float)sqrt2;
    a.m_F32[9] = 77.0f;                 b.m_F32[9] = 77.0f;
    a.m_F32[10] = 187.0f;               b.m_F32[10] = 33.0f;
    a.m_F32[11] = -5.1f;                b.m_F32[11] = -87.0f;
    a.m_F32[12] = 16.0f;                b.m_F32[12] = 936.0f;
    a.m_F32[13] = 0.5f;                 b.m_F32[13] = 0.5f;
    a.m_F32[14] = 2.0f * (float)pi;     b.m_F32[14] = 66.6667f;
    a.m_F32[15] = 1.0f / (float)sqrt2;  b.m_F32[15] = 100.7f;

    PackedCompareF32_avx512(c, &a, &b);

    constexpr int w1 = 10;
    constexpr int w2 = 6;

    std::cout << ("\nPackedCompareF32_avx512() results:\n\n");
    std::cout << std::fixed << std::setprecision(4);
    std::cout << "      a          b    ";

    for (size_t j = 0; j < 8; j++)
        std::cout << std::setw(w2) << c_CmpStr[j];
    std::cout << nl << std::string(70, '-') << nl;

    for (size_t i = 0; i < 16; i++)
    {
        std::cout << std::setw(w1) << a.m_F32[i] << " ";
        std::cout << std::setw(w1) << b.m_F32[i];

        for (size_t j = 0; j < 8; j++)
            std::cout << std::setw(w2) << ((c[j] & (1 << i)) ? 1 : 0);

        std::cout << nl;
    }
}

static void CompareF64(void)
{
    using namespace std::numbers;

    ZmmVal a, b;
    uint8_t c[8];
    constexpr char nl = '\n';
    constexpr double qnan_f64 = std::numeric_limits<double>::quiet_NaN();

    a.m_F64[0] = 2.0;           b.m_F64[0] = e;
    a.m_F64[1] = pi;            b.m_F64[1] = -inv_pi;
    a.m_F64[2] = 12.0;          b.m_F64[2] = 42.0;
    a.m_F64[3] = 33.3333333333; b.m_F64[3] = sqrt2;
    a.m_F64[4] = 0.5;           b.m_F64[4] = e * 2.0;
    a.m_F64[5] = -pi;           b.m_F64[5] = -pi * 2.0;
    a.m_F64[6] = -24.0;         b.m_F64[6] = -24.0;
    a.m_F64[7] = qnan_f64;      b.m_F64[7] = 100.0;

    PackedCompareF64_avx512(c, &a, &b);

    constexpr int w1 = 10;
    constexpr int w2 = 6;

    std::cout << ("\nPackedCompareF64_avx512() results:\n\n");
    std::cout << std::fixed << std::setprecision(4);
    std::cout << "      a          b    ";

    for (size_t j = 0; j < 8; j++)
        std::cout << std::setw(w2) << c_CmpStr[j];
    std::cout << nl << std::string(70, '-') << nl;

    for (size_t i = 0; i < 8; i++)
    {
        std::cout << std::setw(w1) << a.m_F64[i] << " ";
        std::cout << std::setw(w1) << b.m_F64[i];

        for (size_t j = 0; j < 8; j++)
            std::cout << std::setw(w2) << ((c[j] & (1 << i)) ? 1 : 0);

        std::cout << nl;
    }
}

int main(void)
{
    std::cout << "----- Results for Ch14_02 -----\n";

    CompareF32();
    CompareF64();
    return 0;
}
