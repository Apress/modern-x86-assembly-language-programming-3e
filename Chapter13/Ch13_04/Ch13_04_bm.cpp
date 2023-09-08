//-----------------------------------------------------------------------------
// Ch13_04_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch13_04.h"
#include "BmThreadTimer.h"
#include "ImageMatrix.h"

void CalcImageStats_bm(void)
{
    std::cout << "\nRunning benchmark function CalcImageStats_bm() - please wait\n";

    const char* image_fn = g_ImageFileName;

    ImageStats is0, is1;
    ImageMatrix im(image_fn, PixelType::Gray8);
    size_t num_pixels = im.GetNumPixels();
    uint8_t* pb = im.GetPixelBuffer<uint8_t>();

    is0.m_PixelBuffer = pb;
    is0.m_NumPixels = num_pixels;
    is0.m_PixelMinVal = c_PixelMinVal;
    is0.m_PixelMaxVal = c_PixelMaxVal;

    is1.m_PixelBuffer = pb;
    is1.m_NumPixels = num_pixels;
    is1.m_PixelMinVal = c_PixelMinVal;
    is1.m_PixelMaxVal = c_PixelMaxVal;

    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        CalcImageStats_cpp(is0);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        CalcImageStats_avx512(is1);
        bmtt.Stop(i, 1);
    }

    std::string fn = bmtt.BuildCsvFilenameString("@Ch13_04_CalcImageStats_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';
}
