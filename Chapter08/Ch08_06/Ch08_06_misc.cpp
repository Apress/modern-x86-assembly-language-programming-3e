//-----------------------------------------------------------------------------
// Ch08_06_misc.cpp
//-----------------------------------------------------------------------------

#include "Ch08_06.h"
#include "MT.h"

void InitArray(uint8_t* x, uint32_t n, unsigned int rng_seed)
{
    constexpr int rng_min_val = 0;
    constexpr int rng_max_val = 255;
    MT::FillArray(x, n, rng_min_val, rng_max_val, rng_seed);
}
