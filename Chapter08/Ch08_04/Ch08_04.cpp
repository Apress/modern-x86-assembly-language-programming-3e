//-----------------------------------------------------------------------------
// Ch08_04.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch08_04.h"

static void ShiftU16(void)
{
    XmmVal a, c;
    constexpr char nl = '\n';
    constexpr uint32_t count_l = 8;
    constexpr uint32_t count_r = 4;

    a.m_U16[0] = 0x1234;
    a.m_U16[1] = 0xFFB0;
    a.m_U16[2] = 0x00CC;
    a.m_U16[3] = 0x8080;
    a.m_U16[4] = 0x00FF;
    a.m_U16[5] = 0xAAAA;
    a.m_U16[6] = 0x0F0F;
    a.m_U16[7] = 0x0101;

    SllU16_avx(&c, &a, count_l);
    std::cout << "\nSllU16_avx() results ";
    std::cout << "(count = " << count_l << "):\n";
    std::cout << "a: " << a.ToStringX16() << nl;
    std::cout << "c: " << c.ToStringX16() << nl;

    SrlU16_avx(&c, &a, count_r);
    std::cout << "\nSrlU16_avx() results ";
    std::cout << "(count = " << count_r << "):\n";
    std::cout << "a: " << a.ToStringX16() << nl;
    std::cout << "c: " << c.ToStringX16() << nl;

    SraU16_avx(&c, &a, count_r);
    std::cout << "\nSraU16_avx() results";
    std::cout << "(count = " << count_r << "):\n";
    std::cout << "a: " << a.ToStringX16() << nl;
    std::cout << "c: " << c.ToStringX16() << nl;
}

int main()
{
    std::cout << "----- Results for Ch08_04 -----\n";

    ShiftU16();
    return 0;
}
