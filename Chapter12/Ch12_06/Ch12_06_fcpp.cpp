//-----------------------------------------------------------------------------
// Ch12_06_fcpp.cpp
//-----------------------------------------------------------------------------

#include "Ch12_06.h"

bool Convolve1D_Ks5_F64_cpp(double* y, const double* x, const double* kernel,
    int64_t num_pts)
{
    constexpr int64_t kernel_size = 5;
    constexpr int64_t ks2 = kernel_size / 2;

    if (num_pts < kernel_size)
        return false;

    // Perform 1D convolution
    for (int64_t i = ks2; i < num_pts - ks2; i++)
    {
        double y_val = 0.0;

        for (int64_t k = -ks2; k <= ks2; k++)
            y_val += x[i - k] * kernel[k + ks2];

        y[i] = y_val;
    }

    return true;
}
