//-----------------------------------------------------------------------------
// Ch10_05_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch10_05.h"
#include "MT.h"

float g_LUT_U8ToF32[256];           // global LUT for U8 to F32 conversions

void BuildLUT_U8ToF32(void)
{
    size_t n = sizeof(g_LUT_U8ToF32) / sizeof(float);

    for (size_t i = 0; i < n; i++)
        g_LUT_U8ToF32[i] = (float)i / 255.0f;
}

size_t CompareArraysF32(const float* pb_src1, const float* pb_src2,
    size_t num_pixels)
{
    size_t num_diff = 0;

    for (size_t i = 0; i < num_pixels; i++)
    {
        // Exact compare OK since values obtained from LUT
        if (pb_src1[i] != pb_src2[i])
        {
            std::cout << i << ", " << pb_src1[i] << ", " << pb_src2[i] << '\n';
            num_diff++;
        }
    }

    return num_diff;
}

void InitArray(uint8_t* pb, size_t num_pixels)
{
    MT::FillArray(pb, num_pixels, c_FillMinVal, c_FillMaxVal, c_RngSeed);
}
