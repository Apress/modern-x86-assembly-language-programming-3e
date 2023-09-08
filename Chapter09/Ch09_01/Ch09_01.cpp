//-----------------------------------------------------------------------------
// Ch09_01.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <string>
#include <numbers>
#include "Ch09_01.h"

static const char* c_OprStr[8] =
{
    "Add", "Sub", "Mul", "Div", "Min", "Max", "Sqrt a", "Abs b"
};

constexpr size_t c_NumOprStr = sizeof(c_OprStr) / sizeof(char*);

static void PackedMathF32(void)
{
    using namespace std::numbers;
    constexpr char nl = '\n';

    YmmVal a, b, c[c_NumOprStr];

    a.m_F32[0] = 36.0f;                 b.m_F32[0] = -(float)(1.0f / 9.0f);
    a.m_F32[1] = (float)(1.0 / 32.0);   b.m_F32[1] = 64.0f;
    a.m_F32[2] = 2.0f;                  b.m_F32[2] = -0.0625f;
    a.m_F32[3] = 42.0f;                 b.m_F32[3] = 8.666667f;
    a.m_F32[4] = (float)pi;             b.m_F32[4] = -4.0;
    a.m_F32[5] = 18.6f;                 b.m_F32[5] = -64.0f;
    a.m_F32[6] = 3.0f;                  b.m_F32[6] = -5.95f;
    a.m_F32[7] = 142.0f;                b.m_F32[7] = (float)sqrt2;

    PackedMathF32_avx(c, &a, &b);

    std::cout << ("\nPackedMathF32_avx() results:\n");

    for (size_t i = 0; i < 2; i++)
    {
        std::string s0 = (i == 0) ? "a lo:    " : "a hi:    ";
        std::string s1 = (i == 0) ? "b lo:    " : "b hi:    ";

        std::cout << s0 << a.ToStringF32(i) << nl;
        std::cout << s1 << b.ToStringF32(i) << nl;

        for (size_t j = 0; j < c_NumOprStr; j++)
        {
            std::cout << std::setw(9) << std::left << c_OprStr[j];
            std::cout << c[j].ToStringF32(i) << nl;
        }

        if (i == 0)
            std::cout << nl;
    }
}

static void PackedMathF64(void)
{
    using namespace std::numbers;
    constexpr char nl = '\n';

    YmmVal a, b, c[c_NumOprStr];

    a.m_F64[0] = 2.0;          b.m_F64[0] = pi;
    a.m_F64[1] = 4.0;          b.m_F64[1] = e;
    a.m_F64[2] = 7.5;          b.m_F64[2] = -9.125;
    a.m_F64[3] = 3.0;          b.m_F64[3] = -pi;

    PackedMathF64_avx(c, &a, &b);

    std::cout << ("\nPackedMathF64_avx() results:\n");

    for (size_t i = 0; i < 2; i++)
    {
        std::string s0 = (i == 0) ? "a lo:    " : "a hi:    ";
        std::string s1 = (i == 0) ? "b lo:    " : "b hi:    ";

        std::cout << s0 << a.ToStringF64(i) << nl;
        std::cout << s1 << b.ToStringF64(i) << nl;

        for (size_t j = 0; j < c_NumOprStr; j++)
        {
            std::cout << std::setw(9) << std::left << c_OprStr[j];
            std::cout << c[j].ToStringF64(i) << nl;
        }

        if (i == 0)
            std::cout << nl;
    }
}

int main(void)
{
    std::cout << "----- Results for Ch09_01 -----\n";

    PackedMathF32();
    PackedMathF64();
    return 0;
}
