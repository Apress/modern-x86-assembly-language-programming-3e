//-----------------------------------------------------------------------------
// Ch10_04_fcpp.cpp
//-----------------------------------------------------------------------------

#include "Ch10_04.h"

#include <iostream>
#include <stdexcept>
#include "Ch10_04.h"
#include "AlignedMem.h"
#include "ImageMisc.h"

static bool CheckArgs(const uint8_t* pb_gs, const RGB32* pb_rgb,
    size_t num_pixels, const float coef[4])
{
    if (num_pixels == 0)
        return false;

    if (num_pixels % 8 != 0)
        return false;

    if (!AlignedMem::IsAligned(pb_gs, c_Alignment))
        return false;

    if (!AlignedMem::IsAligned(pb_rgb, c_Alignment))
        return false;

    if (coef[0] < 0.0f || coef[1] < 0.0f || coef[2] < 0.0f)
        return false;

    return true;
}

void ConvertRgbToGs_cpp(uint8_t* pb_gs, const RGB32* pb_rgb, size_t num_pixels,
    const float coef[4])
{
    if (!CheckArgs(pb_gs, pb_rgb, num_pixels, coef))
        throw std::runtime_error("ConvertRgbToGs_cpp() - CheckArgs failed");

    for (size_t i = 0; i < num_pixels; i++)
    {
        uint8_t r = pb_rgb[i].m_R;
        uint8_t g = pb_rgb[i].m_G;
        uint8_t b = pb_rgb[i].m_B;

        float gs_temp = r * coef[0] + g * coef[1] + b * coef[2] + 0.5f;

        if (gs_temp > 255.0f)
            gs_temp = 255.0f;

        pb_gs[i] = (uint8_t)gs_temp;
    }
}
