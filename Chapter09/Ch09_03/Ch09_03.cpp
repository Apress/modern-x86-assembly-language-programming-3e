//-----------------------------------------------------------------------------
// Ch09_03.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <numbers>
#include "Ch09_03.h"
#include "XmmVal.h"

static void PackedConvertF32(void)
{
    XmmVal a, b;
    constexpr char nl = '\n';

    a.m_I32[0] = 10;
    a.m_I32[1] = -500;
    a.m_I32[2] = 600;
    a.m_I32[3] = -1024;
    PackedConvertFP_avx(a, b, CvtOp::I32_F32);
    std::cout << "\nCvtOp::I32_F32 results:\n";
    std::cout << "a: " << a.ToStringI32() << nl;
    std::cout << "b: " << b.ToStringF32() << nl;

    a.m_F32[0] = 1.0f / 3.0f;
    a.m_F32[1] = 2.0f / 3.0f;
    a.m_F32[2] = -a.m_F32[0] * 2.0f;
    a.m_F32[3] = -a.m_F32[1] * 2.0f;
    PackedConvertFP_avx(a, b, CvtOp::F32_I32);
    std::cout << "\nCvtOp::F32_I32 results:\n";
    std::cout << "a: " << a.ToStringF32() << nl;
    std::cout << "b: " << b.ToStringI32() << nl;

    // F32_F64 converts the two low-order SPFP values of 'a'
    a.m_F32[0] = 1.0f / 7.0f;
    a.m_F32[1] = 2.0f / 9.0f;
    a.m_F32[2] = 0;
    a.m_F32[3] = 0;
    PackedConvertFP_avx(a, b, CvtOp::F32_F64);
    std::cout << "\nCvtOp::F32_F64 results:\n";
    std::cout << "a: " << a.ToStringF32() << nl;
    std::cout << "b: " << b.ToStringF64() << nl;
}

static void PackedConvertF64(void)
{
    using namespace std::numbers;

    XmmVal a, b;
    constexpr char nl = '\n';

    // I32_F64 converts the two low-order doubleword integers of 'a'
    a.m_I32[0] = 10;
    a.m_I32[1] = -20;
    a.m_I32[2] = 0;
    a.m_I32[3] = 0;
    PackedConvertFP_avx(a, b, CvtOp::I32_F64);
    std::cout << "\nCvtOp::I32_F64 results:\n";
    std::cout << "a: " << a.ToStringI32() << nl;
    std::cout << "b: " << b.ToStringF64() << nl;

    // F64_I32 sets the two high-order doublewords of 'b' to zero
    a.m_F64[0] = pi;
    a.m_F64[1] = e;
    PackedConvertFP_avx(a, b, CvtOp::F64_I32);
    std::cout << "\nCvtOp::F64_I32 results:\n";
    std::cout << "a: " << a.ToStringF64() << nl;
    std::cout << "b: " << b.ToStringI32() << nl;

    // F64_F32 sets the two high-order SPFP values of 'b' to zero
    a.m_F64[0] = sqrt2;
    a.m_F64[1] = 1.0 / sqrt2;
    PackedConvertFP_avx (a, b, CvtOp::F64_F32);
    std::cout << "\nCvtOp::F64_F32 results:\n";
    std::cout << "a: " << a.ToStringF64() << nl;
    std::cout << "b: " << b.ToStringF32() << nl;
}

int main(void)
{
    std::cout << "----- Results for Ch09_03 -----\n";

    PackedConvertF32();
    PackedConvertF64();
    return 0;
}
