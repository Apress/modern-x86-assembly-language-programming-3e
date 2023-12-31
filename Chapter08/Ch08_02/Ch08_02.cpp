//-----------------------------------------------------------------------------
// Ch08_02.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch08_02.h"

static void MulI16(void)
{
    constexpr char nl = '\n';
    XmmVal a, b, c[2];

    a.m_I16[0] = 10;        b.m_I16[0] = -5;
    a.m_I16[1] = 3000;      b.m_I16[1] = 100;
    a.m_I16[2] = -2000;     b.m_I16[2] = -9000;
    a.m_I16[3] = 42;        b.m_I16[3] = 1000;
    a.m_I16[4] = -5000;     b.m_I16[4] = 25000;
    a.m_I16[5] = 8;         b.m_I16[5] = 16384;
    a.m_I16[6] = 10000;     b.m_I16[6] = 3500;
    a.m_I16[7] = -60;       b.m_I16[7] = 6000;

    MulI16_avx(c, &a, &b);

    std::cout << "\nMulI16_avx() results:\n";
    for (size_t i = 0; i < 8; i++)
    {
        std::cout << "a[" << i << "]: " << std::setw(8) << a.m_I16[i] << "  ";
        std::cout << "b[" << i << "]: " << std::setw(8) << b.m_I16[i] << "  ";

        if (i < 4)
        {
            std::cout << "c[0][" << i << "]: ";
            std::cout << std::setw(12) << c[0].m_I32[i] << nl;
        }
        else
        {
            std::cout << "c[1][" << i - 4 << "]: ";
            std::cout << std::setw(12) << c[1].m_I32[i - 4] << nl;
        }
    }
}

static void MulI32a(void)
{
    constexpr char nl = '\n';
    XmmVal a, b, c;

    a.m_I32[0] = 10;        b.m_I32[0] = -500;
    a.m_I32[1] = 3000;      b.m_I32[1] = 100;
    a.m_I32[2] = -2000;     b.m_I32[2] = -12000;
    a.m_I32[3] = 4200;      b.m_I32[3] = 1000;

    MulI32a_avx(&c, &a, &b);

    std::cout << "\nMulI32a_avx() results:\n";
    for (size_t i = 0; i < 4; i++)
    {
        std::cout << "a[" << i << "]: " << std::setw(10) << a.m_I32[i] << "  ";
        std::cout << "b[" << i << "]: " << std::setw(10) << b.m_I32[i] << "  ";
        std::cout << "c[" << i << "]: " << std::setw(10) << c.m_I32[i] << nl;
    }
}

static void MulI32b(void)
{
    constexpr char nl = '\n';
    XmmVal a, b, c[2];

    a.m_I32[0] = 10;        b.m_I32[0] = -500;
    a.m_I32[1] = 3000;      b.m_I32[1] = 100;
    a.m_I32[2] = -40000;    b.m_I32[2] = -1200000;
    a.m_I32[3] = 4200;      b.m_I32[3] = 1000;

    MulI32b_avx(c, &a, &b);

    std::cout << "\nMulI32b_avx() results:\n";
    for (size_t i = 0; i < 4; i++)
    {
        std::cout << "a[" << i << "]: " << std::setw(10) << a.m_I32[i] << "  ";
        std::cout << "b[" << i << "]: " << std::setw(10) << b.m_I32[i] << "  ";

        if (i < 2)
        {
            std::cout << "c[0][" << i << "]: ";
            std::cout << std::setw(14) << c[0].m_I64[i] << nl;
        }
        else
        {
            std::cout << "c[1][" << i - 2 << "]: ";
            std::cout << std::setw(14) << c[1].m_I64[i - 2] << nl;
        }
    }
}

int main()
{
    std::cout << "----- Results for Ch08_02 -----\n";

    MulI16();
    MulI32a();
    MulI32b();
    return 0;
}
