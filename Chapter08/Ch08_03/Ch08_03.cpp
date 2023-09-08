//-----------------------------------------------------------------------------
// Ch08_03.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch08_03.h"

static void BitwiseLogical(void)
{
    XmmVal a, b, c;
    constexpr char nl = '\n';

    a.m_U16[0] = 0x1234;      b.m_U16[0] = 0xFF00;
    a.m_U16[1] = 0xABDC;      b.m_U16[1] = 0x00FF;
    a.m_U16[2] = 0xAA55;      b.m_U16[2] = 0xAAAA;
    a.m_U16[3] = 0x1111;      b.m_U16[3] = 0x5555;
    a.m_U16[4] = 0xFFFF;      b.m_U16[4] = 0x8000;
    a.m_U16[5] = 0x7F7F;      b.m_U16[5] = 0x7FFF;
    a.m_U16[6] = 0x9876;      b.m_U16[6] = 0xF0F0;
    a.m_U16[7] = 0x7F00;      b.m_U16[7] = 0x0880;

    AndU16_avx(&c, &a, &b);
    std::cout << "\nAndU16_avx() results:\n";
    std::cout << "a: " << a.ToStringX16() << nl;
    std::cout << "b: " << b.ToStringX16() << nl;
    std::cout << "c: " << c.ToStringX16() << nl;

    OrU16_avx(&c, &a, &b);
    std::cout << "\nOrU16_avx() results:\n";
    std::cout << "a: " << a.ToStringX16() << nl;
    std::cout << "b: " << b.ToStringX16() << nl;
    std::cout << "c: " << c.ToStringX16() << nl;

    XorU16_avx(&c, &a, &b);
    std::cout << "\nXorU16_avx() results:\n";
    std::cout << "a: " << a.ToStringX16() << nl;
    std::cout << "b: " << b.ToStringX16() << nl;
    std::cout << "c: " << c.ToStringX16() << nl;
}

int main()
{
    std::cout << "----- Results for Ch08_03 -----\n";

    BitwiseLogical();
    return 0;
}
