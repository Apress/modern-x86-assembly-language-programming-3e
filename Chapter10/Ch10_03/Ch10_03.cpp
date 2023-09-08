//-----------------------------------------------------------------------------
// Ch10_03.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <cstring>
#include <limits>
#include <stdexcept>
#include "Ch10_03.h"
#include "AlignedMem.h"

static void ClipPixels(void)
{
    constexpr char nl = '\n';
    constexpr uint8_t thresh_lo = c_ThreshLo;
    constexpr uint8_t thresh_hi = c_ThreshHi;
    constexpr size_t num_pixels = c_NumPixels;
    constexpr size_t ncp_init = std::numeric_limits<size_t>::max();

    AlignedArray<uint8_t> pb_src(num_pixels, c_Alignment);
    AlignedArray<uint8_t> pb_des0(num_pixels, c_Alignment);
    AlignedArray<uint8_t> pb_des1(num_pixels, c_Alignment);

    InitPixelBuffer(pb_src.Data(), num_pixels);

    ClipData cd0;
    cd0.m_PbSrc = pb_src.Data();
    cd0.m_PbDes = pb_des0.Data();
    cd0.m_NumPixels = num_pixels;
    cd0.m_NumClippedPixels = ncp_init;
    cd0.m_ThreshLo = thresh_lo;
    cd0.m_ThreshHi = thresh_hi;

    ClipData cd1;
    cd1.m_PbSrc = pb_src.Data();
    cd1.m_PbDes = pb_des1.Data();
    cd1.m_NumPixels = num_pixels;
    cd1.m_NumClippedPixels = ncp_init;
    cd1.m_ThreshLo = thresh_lo;
    cd1.m_ThreshHi = thresh_hi;

    ClipPixels_cpp(&cd0);
    ClipPixels_avx2(&cd1);

    std::cout << "----- Results for Ch10_03 -----\n";
    std::cout << "num_pixels (test case): " << num_pixels << nl;
    std::cout << "cd0.m_NumClippedPixels: " << cd0.m_NumClippedPixels << nl;
    std::cout << "cd1.m_NumClippedPixels: " << cd1.m_NumClippedPixels << nl;

    bool ncp_check = cd0.m_NumClippedPixels == cd1.m_NumClippedPixels;
    bool mem_check = memcmp(pb_des0.Data(), pb_des1.Data(), num_pixels) == 0;

    if (ncp_check && mem_check)
        std::cout << "\nCompare checks passed\n";
    else
        std::cout << "\nCompare checks failed!\n";
}

int main(void)
{
    try
    {
        ClipPixels();
        ClipPixels_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch10_03 exception: " << ex.what() << '\n';
    }

    return 0;
}
