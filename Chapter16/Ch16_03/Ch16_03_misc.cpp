//-----------------------------------------------------------------------------
// Ch16_03_misc.cpp
//-----------------------------------------------------------------------------

#include "Ch16_03.h"
#include "AlignedMem.h"

bool CheckArgs(const uint8_t* pb_des, const uint8_t* pb_src0,
    const uint8_t* pb_src1, size_t num_pixels)
{
    constexpr size_t align = 64;

    if (num_pixels == 0)
        return false;

    if (num_pixels % 64 != 0)
        return false;

    if (!AlignedMem::IsAligned(pb_src0, align))
        return false;

    if (!AlignedMem::IsAligned(pb_src1, align))
        return false;

    if (!AlignedMem::IsAligned(pb_des, align))
        return false;

    return true;
}
