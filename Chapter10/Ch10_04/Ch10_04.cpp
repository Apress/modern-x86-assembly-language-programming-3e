//-----------------------------------------------------------------------------
// Ch10_04.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <string>
#include <stdexcept>
#include "Ch10_04.h"
#include "ImageMatrix.h"
#include "MF.h"

// Test image file
const char* c_TestImageFileName = "../../Data/TestImageA.png";

// RGB to grayscale conversion coefficients, values must be >= 0
const float c_Coef[4] { 0.2126f, 0.7152f, 0.0722f, 0.0f };

static void ConvertRgbToGs(void)
{
    constexpr char nl = '\n';
    std::string fn_gs0 = MF::BuildHostFilenameString("@Ch10_04_TestImageA_gs0.png");
    std::string fn_gs1 = MF::BuildHostFilenameString("@Ch10_04_TestImageA_gs1.png");

    // Load RGB test image
    ImageMatrix im_rgb(c_TestImageFileName, PixelType::Rgb32);
    size_t im_h = im_rgb.GetHeight();
    size_t im_w = im_rgb.GetWidth();
    size_t num_pixels = im_h * im_w;

    // Create buffers for gray-scale images
    ImageMatrix im_gs0(im_h, im_w, PixelType::Gray8);
    ImageMatrix im_gs1(im_h, im_w, PixelType::Gray8);
    RGB32* pb_rgb = im_rgb.GetPixelBuffer<RGB32>();
    uint8_t* pb_gs0 = im_gs0.GetPixelBuffer<uint8_t>();
    uint8_t* pb_gs1 = im_gs1.GetPixelBuffer<uint8_t>();

    // Exercise conversion functions
    std::cout << "----- Results for Ch10_04 -----\n";
    std::cout << "Converting RGB image " << c_TestImageFileName << nl;
    std::cout << "im_h = " << im_h << " pixels\n";
    std::cout << "im_w = " << im_w << " pixels\n";

    ConvertRgbToGs_cpp(pb_gs0, pb_rgb, num_pixels, c_Coef);
    ConvertRgbToGs_avx2(pb_gs1, pb_rgb, num_pixels, c_Coef);

    // Save results
    std::cout << "Saving grayscale image #0 - " << fn_gs0 << nl;
    im_gs0.SaveImage(fn_gs0.c_str(), ImageFileType::PNG);

    std::cout << "Saving grayscale image #1 - " << fn_gs1 << nl;
    im_gs1.SaveImage(fn_gs1.c_str(), ImageFileType::PNG);

    if (CompareGsPixelBuffers(pb_gs0, pb_gs1, num_pixels))
        std::cout << "Grayscale pixel buffer compare OK\n";
    else
        std::cout << "Grayscale pixel buffer compare failed!\n";
}

int main()
{
    try
    {
        ConvertRgbToGs();
        ConvertRgbToGs_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch10_04 exception: " << ex.what() << '\n';
    }

    return 0;
}
