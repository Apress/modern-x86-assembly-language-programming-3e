//-----------------------------------------------------------------------------
// Ch14_01.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <numbers>
#include "Ch14_01.h"

static void PackedMathF32(void)
{
    using namespace std::numbers;

    ZmmVal a, b, c[9];
    constexpr char nl = '\n';

    a.m_F32[0] = 36.333333f;            b.m_F32[0] = -0.1111111f;
    a.m_F32[1] = 0.03125f;              b.m_F32[1] = 64.0f;
    a.m_F32[2] = 2.0f;                  b.m_F32[2] = -0.0625f;
    a.m_F32[3] = 42.0f;                 b.m_F32[3] = 8.666667f;
    a.m_F32[4] = 7.0f;                  b.m_F32[4] = -18.125f;
    a.m_F32[5] = 20.5f;                 b.m_F32[5] = 56.0f;
    a.m_F32[6] = 36.125f;               b.m_F32[6] = 24.0f;
    a.m_F32[7] = 0.5f;                  b.m_F32[7] = -158.444444f;

    a.m_F32[8] = 136.77777f;            b.m_F32[8] = -9.1111111f;
    a.m_F32[9] = 2.03125f;              b.m_F32[9] = 864.0f;
    a.m_F32[10] = 32.0f;                b.m_F32[10] = -70.0625f;
    a.m_F32[11] = 442.0f;               b.m_F32[11] = 98.666667f;
    a.m_F32[12] = 57.0f;                b.m_F32[12] = -518.125f;
    a.m_F32[13] = 620.5f;               b.m_F32[13] = 456.0f;
    a.m_F32[14] = 736.125f;             b.m_F32[14] = (float)pi;
    a.m_F32[15] = (float)e;             b.m_F32[15] = -298.6f;

    PackedMathF32_avx512(c, &a, &b);

    std::cout << ("PackedMathF32_avx512() results:\n\n");

    for (size_t i = 0; i < 4; i++)
    {
        std::cout << "Group #" << i << nl;
        std::cout << "  a:              " << a.ToStringF32(i) << nl;
        std::cout << "  b:              " << b.ToStringF32(i) << nl;
        std::cout << "  addps:          " << c[0].ToStringF32(i) << nl;
        std::cout << "  addps {rd-sae}: " << c[1].ToStringF32(i) << nl;
        std::cout << "  subps:          " << c[2].ToStringF32(i) << nl;
        std::cout << "  mulps:          " << c[3].ToStringF32(i) << nl;
        std::cout << "  divps:          " << c[4].ToStringF32(i) << nl;
        std::cout << "  minps:          " << c[5].ToStringF32(i) << nl;
        std::cout << "  maxps:          " << c[6].ToStringF32(i) << nl;
        std::cout << "  sqrtps:         " << c[7].ToStringF32(i) << nl;
        std::cout << "  absps:          " << c[8].ToStringF32(i) << nl;
        std::cout << nl;
    }
}

static void PackedMathF64(void)
{
    using namespace std::numbers;

    ZmmVal a, b, c[9];
    constexpr char nl = '\n';

    a.m_F64[0] = e;                 b.m_F64[0] = pi;
    a.m_F64[1] = log10e;            b.m_F64[1] = e / 2.0;
    a.m_F64[2] = sqrt2 / 5.0;       b.m_F64[2] = ln2;
    a.m_F64[3] = 7.0;               b.m_F64[3] = -pi;

    a.m_F64[4] = ln10;              b.m_F64[4] = pi / 3.0;
    a.m_F64[5] = 1.0 / pi;          b.m_F64[5] = 1.0 / e;
    a.m_F64[6] = inv_sqrtpi;        b.m_F64[6] = pi;
    a.m_F64[7] = sqrt2;             b.m_F64[7] = -pi / 2.0;

    PackedMathF64_avx512(c, &a, &b);

    std::cout << ("PackedMathF64_avx512() results:\n\n");

    for (size_t i = 0; i < 4; i++)
    {
        constexpr int p = 16;
        constexpr int w = 32;

        std::cout << "Group #" << i << nl;

        std::cout << "  a:              " << a.ToStringF64(i, w, p) << nl;
        std::cout << "  b:              " << b.ToStringF64(i, w, p) << nl;
        std::cout << "  addpd:          " << c[0].ToStringF64(i, w, p) << nl;
        std::cout << "  subpd:          " << c[1].ToStringF64(i, w, p) << nl;
        std::cout << "  mulpd:          " << c[2].ToStringF64(i, w, p) << nl;
        std::cout << "  divpd:          " << c[3].ToStringF64(i, w, p) << nl;
        std::cout << "  divpd {ru-sae}: " << c[4].ToStringF64(i, w, p) << nl;
        std::cout << "  minpd:          " << c[5].ToStringF64(i, w, p) << nl;
        std::cout << "  maxpd:          " << c[6].ToStringF64(i, w, p) << nl;
        std::cout << "  sqrtpd:         " << c[7].ToStringF64(i, w, p) << nl;
        std::cout << "  abspd:          " << c[8].ToStringF64(i, w, p) << nl;
        std::cout << nl;
    }
}

int main(void)
{
    std::cout << "----- Results for Ch14_01 -----\n\n";

    PackedMathF32();
    PackedMathF64();
    return 0;
}
