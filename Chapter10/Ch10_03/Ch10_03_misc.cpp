//-----------------------------------------------------------------------------
// Ch10_03_misc.cpp
//-----------------------------------------------------------------------------

#include "Ch10_03.h"
#include "MT.h"

void InitPixelBuffer(uint8_t* pb, size_t num_pixels)
{
    // Fill array pb with random values
    MT::FillArray(pb, num_pixels, c_RngMinVal, c_RngMaxVal, c_RngSeed);

    // Insert known values for test & debug
    if (num_pixels >= 31)
    {
        pb[7] = (c_ThreshLo > 0) ? c_ThreshLo - 1 : 0;
        pb[30] = (c_ThreshHi < 255) ? c_ThreshHi + 1 : 255;

        if (num_pixels >= 64)
        {
            pb[33] = (c_ThreshLo > 2) ? c_ThreshLo - 1 : 2;
            pb[35] = (c_ThreshHi < 254) ? c_ThreshHi + 1 : 254;
            pb[62] = 0;
            pb[63] = 255;
        }
    }
}
