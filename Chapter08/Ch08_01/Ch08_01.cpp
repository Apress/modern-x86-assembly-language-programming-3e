//-----------------------------------------------------------------------------
// Ch08_01.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch08_01.h"

static void AddI16(void)
{
    constexpr char nl = '\n';
    XmmVal a, b, c1, c2;

    // Packed int16_t addition
    a.m_I16[0] = 10;          b.m_I16[0] = 100;
    a.m_I16[1] = 200;         b.m_I16[1] = -200;
    a.m_I16[2] = 30;          b.m_I16[2] = 32760;
    a.m_I16[3] = -32766;      b.m_I16[3] = -400;
    a.m_I16[4] = 50;          b.m_I16[4] = 500;
    a.m_I16[5] = 60;          b.m_I16[5] = -600;
    a.m_I16[6] = 32000;       b.m_I16[6] = 1200;
    a.m_I16[7] = -32000;      b.m_I16[7] = -950;

    AddI16_avx(&c1, &c2, &a, &b);

    std::cout << "\nAddI16_avx() results - Wraparound Addition\n";
    std::cout << "a:  " << a.ToStringI16() << nl;
    std::cout << "b:  " << b.ToStringI16() << nl;
    std::cout << "c1: " << c1.ToStringI16() << nl;
    std::cout << "\nAddI16_avx() results - Saturated Addition\n";
    std::cout << "a:  " << a.ToStringI16() << nl;
    std::cout << "b:  " << b.ToStringI16() << nl;
    std::cout << "c2: " << c2.ToStringI16() << nl;
}

static void SubI16(void)
{
    constexpr char nl = '\n';
    XmmVal a, b, c1, c2;

    a.m_I16[0] = 10;          b.m_I16[0] = 100;
    a.m_I16[1] = 200;         b.m_I16[1] = -200;
    a.m_I16[2] = -30;         b.m_I16[2] = 32760;
    a.m_I16[3] = -32766;      b.m_I16[3] = 400;
    a.m_I16[4] = 50;          b.m_I16[4] = 500;
    a.m_I16[5] = 60;          b.m_I16[5] = -600;
    a.m_I16[6] = 32000;       b.m_I16[6] = 1200;
    a.m_I16[7] = -32000;      b.m_I16[7] = 950;

    SubI16_avx(&c1, &c2, &a, &b);

    std::cout << "\nSubI16_avx() results - Wraparound Subtraction\n";
    std::cout << "a:  " << a.ToStringI16() << nl;
    std::cout << "b:  " << b.ToStringI16() << nl;
    std::cout << "c1: " << c1.ToStringI16() << nl;
    std::cout << "\nSubI16_avx() results - Saturated Subtraction\n";
    std::cout << "a:  " << a.ToStringI16() << nl;
    std::cout << "b:  " << b.ToStringI16() << nl;
    std::cout << "c2: " << c2.ToStringI16() << nl;
}

int main()
{
    std::cout << "----- Results for Ch08_01 -----\n";

    AddI16();
    SubI16();
    return 0;
}
