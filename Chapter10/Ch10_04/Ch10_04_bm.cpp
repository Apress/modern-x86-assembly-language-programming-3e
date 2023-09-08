//-----------------------------------------------------------------------------
// Ch10_04_bm.cpp
//-----------------------------------------------------------------------------

#include <string>
#include "Ch10_04.h"
#include "BmThreadTimer.h"
#include "ImageMatrix.h"

void ConvertRgbToGs_bm(void)
{
    std::cout << "\nRunning benchmark function ConvertRgbToGs_bm() - please wait\n";

    ImageMatrix im_rgb(c_TestImageFileName, PixelType::Rgb32);
    size_t im_h = im_rgb.GetHeight();
    size_t im_w = im_rgb.GetWidth();
    size_t num_pixels = im_h * im_w;

    ImageMatrix im_gs0(im_h, im_w, PixelType::Gray8);
    ImageMatrix im_gs1(im_h, im_w, PixelType::Gray8);
    RGB32* pb_rgb = im_rgb.GetPixelBuffer<RGB32>();
    uint8_t* pb_gs0 = im_gs0.GetPixelBuffer<uint8_t>();
    uint8_t* pb_gs1 = im_gs1.GetPixelBuffer<uint8_t>();

    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        ConvertRgbToGs_cpp(pb_gs0, pb_rgb, num_pixels, c_Coef);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        ConvertRgbToGs_avx2(pb_gs1, pb_rgb, num_pixels, c_Coef);
        bmtt.Stop(i, 1);
    }

    std::string fn = bmtt.BuildCsvFilenameString("@Ch10_04_ConvertRgbToGs_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';
}
