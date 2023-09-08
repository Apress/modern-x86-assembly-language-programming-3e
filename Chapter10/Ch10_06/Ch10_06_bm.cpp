//-----------------------------------------------------------------------------
// Ch10_06_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch10_06.h"
#include "AlignedMem.h"
#include "BmThreadTimer.h"
#include "ImageMatrix.h"

void BuildHistogram_bm(void)
{
    std::cout << "\nRunning benchmark function BuildHistogram_bm() - please wait\n";

    const char* image_fn = g_ImageFileName;
    constexpr size_t histo_size = c_HistoSize;

    ImageMatrix im(image_fn, PixelType::Gray8);
    size_t num_pixels = im.GetNumPixels();
    uint8_t* pb = im.GetPixelBuffer<uint8_t>();

    AlignedArray<uint32_t> histo0_aa(histo_size, c_Alignment);
    AlignedArray<uint32_t> histo1_aa(histo_size, c_Alignment);
    uint32_t* histo0 = histo0_aa.Data();
    uint32_t* histo1 = histo1_aa.Data();

    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        BuildHistogram_cpp(histo0, pb, num_pixels);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        BuildHistogram_avx2(histo1, pb, num_pixels);
        bmtt.Stop(i, 1);

        if ((i % 40) == 0)
            std::cout << '.' << std::flush;
    }

    std::cout << '\n';
    std::string fn = bmtt.BuildCsvFilenameString("@Ch10_06_BuildHistogram_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';
}
