//-----------------------------------------------------------------------------
// Ch13_03.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <cassert>
#include <stdexcept>
#include "Ch13_03.h"
#include "AlignedMem.h"

static void ComparePixels(void)
{
    constexpr size_t num_pixels = 4 * 1024 * 1024;
    AlignedArray<uint8_t> src_aa(num_pixels, c_Alignment);
    AlignedArray<uint8_t> des1_aa(num_pixels, c_Alignment);
    AlignedArray<uint8_t> des2_aa(num_pixels, c_Alignment);

    uint8_t* src = src_aa.Data();
    uint8_t* des1 = des1_aa.Data();
    uint8_t* des2 = des2_aa.Data();

    constexpr uint8_t cmp_vals[] { 197, 222, 43, 43, 129, 222 };
    constexpr CmpOp cmp_ops[] { CmpOp::EQ, CmpOp::NE, CmpOp::LT, CmpOp::LE,
                                CmpOp::GT, CmpOp::GE };
    constexpr size_t num_cmp_vals = sizeof(cmp_vals) / sizeof(uint8_t);
    constexpr size_t num_cmp_ops = sizeof(cmp_ops) / sizeof(CmpOp);

    assert(num_cmp_vals == num_cmp_ops);

    InitArray(src, num_pixels, 511);

    std::cout << "----- Results for Ch13_03 -----\n";

    for (size_t i = 0; i < num_cmp_ops; i++)
    {
        ComparePixels_cpp(des1, src, num_pixels, cmp_ops[i], cmp_vals[i]);
        ComparePixels_avx512(des2, src, num_pixels, cmp_ops[i], cmp_vals[i]);
        DisplayResults(des1, des2, num_pixels, cmp_ops[i], cmp_vals[i], i + 1);
    }
}

int main(void)
{
    try
    {
        ComparePixels();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch13_03 exception: " << ex.what() << '\n';
    }

    return 0;
}
