//-----------------------------------------------------------------------------
// Ch10_04_misc.cpp
//-----------------------------------------------------------------------------

#include "Ch10_04.h"
#include <cstdlib>

bool CompareGsPixelBuffers(const uint8_t* pb_gs1, const uint8_t* pb_gs2,
    size_t num_pixels)
{
    for (size_t i = 0; i < num_pixels; i++)
    {
        if (abs((int)pb_gs1[i] - (int)pb_gs2[i]) > 1)
            return false;
    }

    return true;
}
