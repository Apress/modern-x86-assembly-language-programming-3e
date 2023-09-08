//-----------------------------------------------------------------------------
// Ch16_03.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <string>
#include <stdexcept>
#include "Ch16_03.h"
#include "AlignedMem.h"
#include "ImageMatrix.h"
#include "MF.h"

const char* g_ImageFileName0 = "../../Data/TestImageD0.png";
const char* g_ImageFileName1 = "../../Data/TestImageD1.png";

static void AbsImage(void)
{
    constexpr char nl = '\n';
    std::string im_src0_fn(g_ImageFileName0);
    std::string im_src1_fn(g_ImageFileName1);
    std::string im_des0_fn = MF::BuildHostFilenameString("@Ch16_03_AbsImage0.png");
    std::string im_des1_fn = MF::BuildHostFilenameString("@Ch16_03_AbsImage1.png");
    std::string im_des2_fn = MF::BuildHostFilenameString("@Ch16_03_AbsImage2.png");

    std::cout << "----- Results for Ch16_03 -----\n\n";

    // Load source images
    std::cout << "Loading source image #0: " << im_src0_fn << nl;
    ImageMatrix im_src0(im_src0_fn, PixelType::Gray8);
    uint8_t* pb_src0 = im_src0.GetPixelBuffer<uint8_t>();
    size_t num_pixels0 = im_src0.GetNumPixels();

    std::cout << "Loading source image #1: " << im_src1_fn << nl;
    ImageMatrix im_src1(im_src1_fn, PixelType::Gray8);
    uint8_t* pb_src1 = im_src1.GetPixelBuffer<uint8_t>();
    size_t num_pixels1 = im_src1.GetNumPixels();

    if (num_pixels0 != num_pixels1)
        throw std::runtime_error("AbsImage() - pixel counts do not match!");
    std::cout << "Number of pixels: " << num_pixels0 << nl;

    // Create destination images
    ImageMatrix im_des0(im_src0);
    uint8_t* pb_des0 = im_des0.GetPixelBuffer<uint8_t>();

    ImageMatrix im_des1(im_src0);
    uint8_t* pb_des1 = im_des1.GetPixelBuffer<uint8_t>();

    ImageMatrix im_des2(im_src0);
    uint8_t* pb_des2 = im_des2.GetPixelBuffer<uint8_t>();

    // Calculate abs images
    bool rc1 = AbsImage_cpp(pb_des0, pb_src0, pb_src1, num_pixels0);
    bool rc2 = AbsImage_avx2(pb_des1, pb_src0, pb_src1, num_pixels0);
    bool rc3 = AbsImageNT_avx2(pb_des2, pb_src0, pb_src1, num_pixels0);

    if (!rc1)
        throw std::runtime_error("Function AbsImage_cpp() failed!");

    std::cout << "Saving destination image #0: " << im_des0_fn << nl;
    im_des0.SaveImage(im_des0_fn, ImageFileType::PNG);

    if (!rc2)
        throw std::runtime_error("Function AbsImage_avx2() failed!");

    std::cout << "Saving destination image #1: " << im_des1_fn << nl;
    im_des1.SaveImage(im_des1_fn, ImageFileType::PNG);

    if (!rc3)
        throw std::runtime_error("Function AbsImageNT_avx2() failed!");

    std::cout << "Saving destination image #2: " << im_des2_fn << nl;
    im_des2.SaveImage(im_des2_fn, ImageFileType::PNG);

    if (im_des0 == im_des1 && im_des1 == im_des2)
        std::cout << "Destination image compare test passed\n";
    else
        std::cout << "Destination image compare test failed!\n";
}

int main(void)
{
    try
    {
        AbsImage();
        AbsImage_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch16_03 exception: " << ex.what() << '\n';
    }

    return 0;
}
