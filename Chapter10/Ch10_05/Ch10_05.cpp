//-----------------------------------------------------------------------------
// Ch10_05.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <stdexcept>
#include <iostream>
#include "Ch10_05.h"
#include "AlignedMem.h"
#include "MT.h"

static void ConvertU8ToF32()
{
    constexpr char nl = '\n';
    size_t num_pixels = c_NumPixels;
    AlignedArray<uint8_t> pb_src_aa(num_pixels, c_Alignment);
    AlignedArray<float> pb_des0_aa(num_pixels, c_Alignment);
    AlignedArray<float> pb_des1_aa(num_pixels, c_Alignment);

    uint8_t* pb_src = pb_src_aa.Data();
    float* pb_des0 = pb_des0_aa.Data();
    float* pb_des1 = pb_des1_aa.Data();

    InitArray(pb_src, num_pixels);

    ConvertU8ToF32_cpp(pb_des0, pb_src, num_pixels);
    ConvertU8ToF32_avx2(pb_des1, pb_src, num_pixels);

    size_t num_diff = CompareArraysF32(pb_des0, pb_des1, num_pixels);

    std::cout << "----- Results for Ch10_05 -----\n";
    std::cout << "num_pixels (test case): " << num_pixels << nl;
    std::cout << "num_diff:               " << num_diff << nl;

    if (num_diff == 0)
        std::cout << "Pixel buffer compare test passed\n";
    else
        std::cout << "Pixel buffer compare test FAILED!\n";
}

int main(void)
{
    try
    {
        BuildLUT_U8ToF32();
        ConvertU8ToF32();
        ConvertU8ToF32_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch10_05 exception: " << ex.what() << '\n';
    }

    return 0;
}
