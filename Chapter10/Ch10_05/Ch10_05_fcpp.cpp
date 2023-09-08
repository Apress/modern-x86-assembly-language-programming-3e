//-----------------------------------------------------------------------------
// Ch10_05_fcpp.cpp
//-----------------------------------------------------------------------------

#include <stdexcept>
#include "Ch10_05.h"
#include "AlignedMem.h"

static bool CheckArgs(const void* pb1, const void* pb2, size_t num_pixels)
{
    if (num_pixels == 0)
        return false;

    if (!AlignedMem::IsAligned(pb1, c_Alignment))
        return false;

    if (!AlignedMem::IsAligned(pb2, c_Alignment))
        return false;

    return true;
}

void ConvertU8ToF32_cpp(float* pb_des, const uint8_t* pb_src, size_t num_pixels)
{
    if (!CheckArgs(pb_des, pb_src, num_pixels))
        throw std::runtime_error("ConvertU8ToF32_cpp() CheckArgs failed");

    for (size_t i = 0; i < num_pixels; i++)
        pb_des[i] = g_LUT_U8ToF32[pb_src[i]];
}

