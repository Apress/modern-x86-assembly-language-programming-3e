//-----------------------------------------------------------------------------
// Ch10_05_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <string>
#include "Ch10_05.h"
#include "AlignedMem.h"
#include "MT.h"
#include "BmThreadTimer.h"

void ConvertU8ToF32_bm(void)
{
    std::cout << "\nRunning benchmark function ConvertU8ToF32_bm() - please wait\n";

    size_t num_pixels = c_NumPixelsBM;
    AlignedArray<uint8_t> pb_src_aa(num_pixels, c_Alignment);
    AlignedArray<float> pb_des0_aa(num_pixels, c_Alignment);
    AlignedArray<float> pb_des1_aa(num_pixels, c_Alignment);

    uint8_t* pb_src = pb_src_aa.Data();
    float* pb_des0 = pb_des0_aa.Data();
    float* pb_des1 = pb_des1_aa.Data();

    InitArray(pb_src, num_pixels);

    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        ConvertU8ToF32_cpp(pb_des0, pb_src, num_pixels);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        ConvertU8ToF32_avx2(pb_des1, pb_src, num_pixels);
        bmtt.Stop(i, 1);
    }

    std::string fn = bmtt.BuildCsvFilenameString("@Ch10_05_ConvertU8ToF32_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';
}
