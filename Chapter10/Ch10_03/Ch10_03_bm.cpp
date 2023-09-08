//-----------------------------------------------------------------------------
// Ch10_03_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <string>
#include <cstring>
#include "AlignedMem.h"
#include "BmThreadTimer.h"
#include "Ch10_03.h"

void ClipPixels_bm(void)
{
    std::cout << "\nRunning benchmark function ClipPixels_bm() - please wait\n";

    constexpr uint8_t thresh_lo = c_ThreshLo;
    constexpr uint8_t thresh_hi = c_ThreshHi;
    constexpr size_t num_pixels = c_NumPixelsBM;

    AlignedArray<uint8_t> pb_src(num_pixels, c_Alignment);
    AlignedArray<uint8_t> pb_des0(num_pixels, c_Alignment);
    AlignedArray<uint8_t> pb_des1(num_pixels, c_Alignment);

    InitPixelBuffer(pb_src.Data(), num_pixels);

    ClipData cd0;
    cd0.m_PbSrc = pb_src.Data();
    cd0.m_PbDes = pb_des0.Data();
    cd0.m_NumPixels = num_pixels;
    cd0.m_NumClippedPixels = (std::numeric_limits<size_t>::max)();
    cd0.m_ThreshLo = thresh_lo;
    cd0.m_ThreshHi = thresh_hi;

    ClipData cd1;
    cd1.m_PbSrc = pb_src.Data();
    cd1.m_PbDes = pb_des1.Data();
    cd1.m_NumPixels = num_pixels;
    cd1.m_NumClippedPixels = (std::numeric_limits<size_t>::max)();
    cd1.m_ThreshLo = thresh_lo;
    cd1.m_ThreshHi = thresh_hi;

    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        ClipPixels_cpp(&cd0);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        ClipPixels_avx2(&cd1);
        bmtt.Stop(i, 1);
    }

    bool ncp_check = cd0.m_NumClippedPixels == cd1.m_NumClippedPixels;
    bool mem_check = memcmp(pb_des0.Data(), pb_des1.Data(), num_pixels) == 0;

    if (!ncp_check || !mem_check)
        std::cout << "\nBenchmark compare checks failed!\n";

    std::string fn = bmtt.BuildCsvFilenameString("@Ch10_03_ClipPixels_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';
}
