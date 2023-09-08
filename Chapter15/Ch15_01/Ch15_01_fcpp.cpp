//-----------------------------------------------------------------------------
// Ch15_01_fcpp.cpp
//-----------------------------------------------------------------------------

#include "Ch15_01.h"

bool Convolve1D_F32_cpp(float* y, const float* x, const float* kernel,
    int64_t num_pts, int64_t kernel_size)
{
    // Validate arguments
    if (kernel_size < 3)
        return false;

    if ((kernel_size & 1) == 0)
        return false;

    if (num_pts < kernel_size)
        return false;

    // Perform 1D convolution
    int64_t ks2 = kernel_size / 2;

    for (int64_t i = ks2; i < num_pts - ks2; i++)
    {
        float y_val = 0.0f;

        for (int64_t k = -ks2; k <= ks2; k++)
            y_val += x[i - k] * kernel[k + ks2];

        y[i] = y_val;
    }

    return true;
}
