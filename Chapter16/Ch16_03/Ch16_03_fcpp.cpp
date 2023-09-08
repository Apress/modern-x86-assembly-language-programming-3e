//-----------------------------------------------------------------------------
// Ch16_03_fcpp.cpp
//-----------------------------------------------------------------------------

#include <cmath>
#include "Ch16_03.h"

bool AbsImage_cpp(uint8_t* pb_des, const uint8_t* pb_src0,
    const uint8_t* pb_src1, size_t num_pixels)
{
    if (!CheckArgs(pb_des, pb_src0, pb_src1, num_pixels))
        return false;

    for (size_t i = 0; i < num_pixels; i++)
        pb_des[i] = (uint8_t)abs(pb_src0[i] - pb_src1[i]);

    return true;
}
