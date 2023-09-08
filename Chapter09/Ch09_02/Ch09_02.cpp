//-----------------------------------------------------------------------------
// Ch09_02.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <string>
#include <limits>
#include <numbers>
#include "Ch09_02.h"

static const char* c_CmpStr[8] =
{
    "EQ", "NE", "LT", "LE", "GT", "GE", "ORDERED", "UNORDERED"
};

constexpr size_t c_NumCmpStr = sizeof(c_CmpStr) / sizeof(char*);

static void PackedCompareF32()
{
    using namespace std::numbers;

    constexpr char nl = '\n';
    constexpr float qnan_f32 = std::numeric_limits<float>::quiet_NaN();
    YmmVal a, b, c[c_NumCmpStr];

    a.m_F32[0] = 2.0f;              b.m_F32[0] = 1.0f;
    a.m_F32[1] = 7.0f;              b.m_F32[1] = 12.0f;
    a.m_F32[2] = -6.0f;             b.m_F32[2] = -6.0f;
    a.m_F32[3] = 3.0f;              b.m_F32[3] = 8.0f;
    a.m_F32[4] = -16.0f;            b.m_F32[4] = -36.0f;
    a.m_F32[5] = 3.5f;              b.m_F32[5] = 3.5f;
    a.m_F32[6] = (float)pi;         b.m_F32[6] = -6.0f;
    a.m_F32[7] = (float)sqrt2;      b.m_F32[7] = qnan_f32;

    PackedCompareF32_avx(c, &a, &b);

    std::cout << ("\nPackedCompareF32_avx() results:\n");

    for (size_t i = 0; i < 2; i++)
    {
        std::string s0 = (i == 0) ? "a lo:    " : "a hi:    ";
        std::string s1 = (i == 0) ? "b lo:    " : "b hi:    ";

        std::cout << s0 << a.ToStringF32(i) << nl;
        std::cout << s1 << b.ToStringF32(i) << nl;

        for (size_t j = 0; j < c_NumCmpStr; j++)
        {
            std::cout << std::setw(9) << std::left << c_CmpStr[j];
            std::cout << c[j].ToStringX32(i) << nl;
        }

        if (i == 0)
            std::cout << nl;
    }
}

static void PackedCompareF64()
{
    using namespace std::numbers;

    constexpr char nl = '\n';
    constexpr double qnan_f64 = std::numeric_limits<double>::quiet_NaN();
    YmmVal a, b, c[c_NumCmpStr];

    a.m_F64[0] = 2.0;       b.m_F64[0] = e;
    a.m_F64[1] = pi  ;      b.m_F64[1] = -1.0 / pi;
    a.m_F64[2] = 12.0;      b.m_F64[2] = 42.0;
    a.m_F64[3] = qnan_f64;  b.m_F64[3] = sqrt2;

    PackedCompareF64_avx(c, &a, &b);

    std::cout << ("\nPackedCompareF64_avx() results:\n");

    for (size_t i = 0; i < 2; i++)
    {
        std::string s0 = (i == 0) ? "a lo:    " : "a hi:    ";
        std::string s1 = (i == 0) ? "b lo:    " : "b hi:    ";

        std::cout << s0 << a.ToStringF64(i) << nl;
        std::cout << s1 << b.ToStringF64(i) << nl;

        for (size_t j = 0; j < c_NumCmpStr; j++)
        {
            std::cout << std::setw(9) << std::left << c_CmpStr[j];
            std::cout << c[j].ToStringX64(i) << nl;
        }

        if (i == 0)
            std::cout << nl;
    }
}

int main(void)
{
    std::cout << "----- Results for Ch09_02 -----\n";

    PackedCompareF32();
    PackedCompareF64();
    return 0;
}
