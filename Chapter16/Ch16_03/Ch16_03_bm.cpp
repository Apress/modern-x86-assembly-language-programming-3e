//-----------------------------------------------------------------------------
// Ch16_03_bm.cpp
//-----------------------------------------------------------------------------

#include <string>
#include <stdexcept>
#include "Ch16_03.h"
#include "BmThreadTimer.h"
#include "ImageMatrix.h"

void AbsImage_bm(void)
{
    std::cout << "\nRunning benchmark function AbsImage_bm() - please wait\n";

    std::string im_src0_fn(g_ImageFileName0);
    std::string im_src1_fn(g_ImageFileName1);

    // Load source images
    ImageMatrix im_src0(im_src0_fn, PixelType::Gray8);
    uint8_t* pb_src0 = im_src0.GetPixelBuffer<uint8_t>();
    size_t num_pixels0 = im_src0.GetNumPixels();

    ImageMatrix im_src1(im_src1_fn, PixelType::Gray8);
    uint8_t* pb_src1 = im_src1.GetPixelBuffer<uint8_t>();
    size_t num_pixels1 = im_src1.GetNumPixels();

    if (num_pixels0 != num_pixels1)
        throw std::runtime_error("AbsImage_bm() - pixel counts do not match!");

    // Create destination images
    ImageMatrix im_des0(im_src0);
    uint8_t* pb_des0 = im_des0.GetPixelBuffer<uint8_t>();

    ImageMatrix im_des1(im_src0);
    uint8_t* pb_des1 = im_des1.GetPixelBuffer<uint8_t>();

    ImageMatrix im_des2(im_src0);
    uint8_t* pb_des2 = im_des2.GetPixelBuffer<uint8_t>();

    // Perform timing measurements
    constexpr size_t num_alg = 3;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;

    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        AbsImage_cpp(pb_des0, pb_src0, pb_src1, num_pixels0);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        AbsImage_avx2(pb_des1, pb_src0, pb_src1, num_pixels0);
        bmtt.Stop(i, 1);

        bmtt.Start(i, 2);
        AbsImageNT_avx2(pb_des2, pb_src0, pb_src1, num_pixels0);
        bmtt.Stop(i, 2);
    }

    if (im_des0 == im_des1 && im_des1 == im_des2)
        std::cout << "\n";
    else
        std::cout << "Destination image compare test failed!\n";

     std::string fn = bmtt.BuildCsvFilenameString("@Ch16_03_AbsImage_bm");
     bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
     std::cout << "Benchmark times saved to file " << fn << '\n';
}
