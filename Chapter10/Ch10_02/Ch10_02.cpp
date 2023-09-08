//-----------------------------------------------------------------------------
// Ch10_02.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <cstddef>
#include <cstdint>
#include "Ch10_02.h"

static void ZeroExtU8_U16(void)
{
    YmmVal a, c[2];

    for (size_t i = 0; i < 32; i++)
        a.m_U8[i] = (uint8_t)(i * 8);

    // Zero-extend U8 integers to U16
    ZeroExtU8_U16_avx2(c, &a);

    constexpr char nl = '\n';
    std::cout << "\nZeroExtU8_U16_avx2() results:\n";

    std::cout << "a (0:15):   " << a.ToStringU8(0) << nl;
    std::cout << "a (16:31):  " << a.ToStringU8(1) << nl;
    std::cout << nl;
    std::cout << "c (0:7):    " << c[0].ToStringU16(0) << nl;
    std::cout << "c (8:15):   " << c[0].ToStringU16(1) << nl;
    std::cout << "c (16:23):  " << c[1].ToStringU16(0) << nl;
    std::cout << "c (24:31):  " << c[1].ToStringU16(1) << nl;
}

static void ZeroExtU8_U32(void)
{
    YmmVal a, c[4];

    for (size_t i = 0; i < 32; i++)
        a.m_U8[i] = (uint8_t)(255 - i * 8);

    // Zero-extend U8 integers to U32
    ZeroExtU8_U32_avx2(c, &a);

    constexpr char nl = '\n';
    std::cout << "\nZeroExtU8_U32_avx2() results:\n";

    std::cout << "a (0:15):   " << a.ToStringU8(0) << nl;
    std::cout << "a (16:31):  " << a.ToStringU8(1) << nl;
    std::cout << nl;
    std::cout << "c (0:3):    " << c[0].ToStringU32(0) << nl;
    std::cout << "c (4:7):    " << c[0].ToStringU32(1) << nl;
    std::cout << "c (8:11):   " << c[1].ToStringU32(0) << nl;
    std::cout << "c (12:15):  " << c[1].ToStringU32(1) << nl;
    std::cout << "c (16:19):  " << c[2].ToStringU32(0) << nl;
    std::cout << "c (20:23):  " << c[2].ToStringU32(1) << nl;
    std::cout << "c (24:27):  " << c[3].ToStringU32(0) << nl;
    std::cout << "c (28:31):  " << c[3].ToStringU32(1) << nl;
}

static void SignExtI16_I32(void)
{
    YmmVal a, c[2];

    for (size_t i = 0; i < 16; i++)
        a.m_I16[i] = (int16_t)(-32768 + i * 4000);

    // Sign-extend I16 integers to I32
    SignExtI16_I32_avx2(c, &a);

    constexpr char nl = '\n';
    std::cout << "\nSignExtI16_I32_avx2() results:\n";

    std::cout << "a (0:7):    " << a.ToStringI16(0) << nl;
    std::cout << "a (8:15):   " << a.ToStringI16(1) << nl;
    std::cout << nl;
    std::cout << "c (0:3):    " << c[0].ToStringI32(0) << nl;
    std::cout << "c (4:7):    " << c[0].ToStringI32(1) << nl;
    std::cout << "c (8:11):   " << c[1].ToStringI32(0) << nl;
    std::cout << "c (12:15):  " << c[1].ToStringI32(1) << nl;
}

static void SignExtI16_I64(void)
{
    YmmVal a, c[4];

    for (size_t i = 0; i < 16; i++)
        a.m_I16[i] = (int16_t)(32767 - i * 4000);

    // Sign-extend I16 integers to I64
    SignExtI16_I64_avx2(c, &a);

    constexpr char nl = '\n';
    std::cout << "\nSignExtI16_I64_avx2() results:\n";

    std::cout << "a (0:7):    " << a.ToStringI16(0) << nl;
    std::cout << "a (8:15):   " << a.ToStringI16(1) << nl;
    std::cout << nl;
    std::cout << "c (0:1):    " << c[0].ToStringI64(0) << nl;
    std::cout << "c (2:3):    " << c[0].ToStringI64(1) << nl;
    std::cout << "c (4:5):    " << c[1].ToStringI64(0) << nl;
    std::cout << "c (6:7):    " << c[1].ToStringI64(1) << nl;
    std::cout << "c (8:9):    " << c[2].ToStringI64(0) << nl;
    std::cout << "c (10:11):  " << c[2].ToStringI64(1) << nl;
    std::cout << "c (12:13):  " << c[3].ToStringI64(0) << nl;
    std::cout << "c (14:15):  " << c[3].ToStringI64(1) << nl;
}

int main(void)
{
    std::cout << "----- Results for Ch10_02 -----\n";

    ZeroExtU8_U16();
    ZeroExtU8_U32();
    SignExtI16_I32();
    SignExtI16_I64();
    return 0;
}
