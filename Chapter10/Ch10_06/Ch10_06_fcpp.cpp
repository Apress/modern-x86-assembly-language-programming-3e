//-----------------------------------------------------------------------------
// Ch10_06_fcpp.cpp
//-----------------------------------------------------------------------------

#include <cstring>
#include <stdexcept>
#include "Ch10_06.h"
#include "AlignedMem.h"

static bool CheckArgs(uint32_t* histo, const uint8_t* pixel_buff,
    size_t num_pixels)
{
    if (!AlignedMem::IsAligned(histo, c_Alignment))
        return false;
    if (!AlignedMem::IsAligned(pixel_buff, c_Alignment))
        return false;

    if (num_pixels == 0)
        return false;
    if (num_pixels % 32 != 0)
        return false;

    return true;
}

bool BuildHistogram_cpp(uint32_t* histo, const uint8_t* pixel_buff,
    size_t num_pixels)
{
    if (!CheckArgs(histo, pixel_buff, num_pixels))
        throw std::runtime_error("BuildHistogram_cpp() CheckArgs failed");

    memset(histo, 0x00, c_HistoSize * sizeof(uint32_t));

    for (size_t i = 0; i < num_pixels; i++)
        histo[pixel_buff[i]]++;

    return true;
}
