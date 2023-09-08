//-----------------------------------------------------------------------------
// Ch15_01.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <stdexcept>
#include <vector>
#include "Ch15_01.h"
#include "MT_Convolve.h"

static void Convolve1D_F32(void)
{
    constexpr char nl = '\n';
    const char* bn_results = "@Ch15_01_Convolve1D_F32_Output";

    std::cout << "----- Results for Ch15_01 -----\n";
    std::cout << "Executing Convolve1D_F32()" << nl;

    constexpr int64_t num_pts = 67;
    const std::vector<float> kernel { 0.0625f, 0.25f, 0.375f, 0.25f, 0.0625f };

    // Create signal array
    std::vector<float> x(num_pts);
    GenSignal1D(x, c_RngSeed);

    // Create result arrays
    std::vector<float> y1(num_pts);
    std::vector<float> y2(num_pts);

    // Perform 1D convolutions
    bool rc1 = Convolve1D_F32_cpp(y1.data(), x.data(), kernel.data(),
        x.size(), kernel.size());

    bool rc2 = Convolve1D_F32_avx512(y2.data(), x.data(), kernel.data(),
        x.size(), kernel.size());

    // Save results
    if (rc1 && rc2)
    {
        std::vector<std::vector<float>*> signal_vectors{ &x, &y1, &y2 };
        std::vector<std::string> titles { "x", "y1", "y2" };
        std::string results_fn = SaveResults1D(bn_results, signal_vectors, titles);
        std::cout << "Calculated results saved to file " << results_fn << nl;
    }
    else
    {
        std::cout << "Error occurred during convolution\n";
        std::cout << "rc1: " << std::boolalpha << rc1 << nl;
        std::cout << "rc2: " << std::boolalpha << rc2 << nl;
    }
}

int main(void)
{
    try
    {
        Convolve1D_F32();
        Convolve1D_F32_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch15_01 exception: " << ex.what() << '\n';
    }

    return 0;
}
