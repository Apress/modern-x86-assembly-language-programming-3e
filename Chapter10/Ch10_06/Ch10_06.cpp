//-----------------------------------------------------------------------------
// Ch10_06.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <stdexcept>
#include "Ch10_06.h"
#include "ImageMatrix.h"
#include "AlignedMem.h"

const char* g_ImageFileName = "../../Data/TestImageB.png";

static void BuildHistogram(void)
{
    const char* image_fn = g_ImageFileName;
    constexpr size_t histo_size = c_HistoSize;

    ImageMatrix im(image_fn, PixelType::Gray8);
    size_t num_pixels = im.GetNumPixels();
    uint8_t* pb = im.GetPixelBuffer<uint8_t>();

    AlignedArray<uint32_t> histo0_aa(histo_size, c_Alignment);
    AlignedArray<uint32_t> histo1_aa(histo_size, c_Alignment);
    uint32_t* histo0 = histo0_aa.Data();
    uint32_t* histo1 = histo1_aa.Data();

    bool rc0 = BuildHistogram_cpp(histo0, pb, num_pixels);
    bool rc1 = BuildHistogram_avx2(histo1, pb, num_pixels);

    std::cout << "----- Results for Ch10_06 -----\n";
    SaveHistograms(histo0, histo1, histo_size, rc0, rc1);
}

int main(void)
{
    try
    {
        BuildHistogram();
        BuildHistogram_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch10_06 exception: " << ex.what() << '\n';
    }

    return 0;
}
