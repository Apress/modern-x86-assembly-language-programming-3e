//-----------------------------------------------------------------------------
// Ch15_04.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <stdexcept>
#include <vector>
#include "Ch15_04.h"
#include "MT_Convolve.h"

static void Convolve1D_Ks5_F64(void)
{
    constexpr char nl = '\n';
    const char* bn_results = "@Ch15_04_Convolve1D_Ks5_F64_Output";

    std::cout << "----- Results for Ch15_04 -----\n";
    std::cout << "Executing Convolve1D_Ks5_F64()" << nl;

    constexpr int64_t num_pts = 67;
    const std::vector<double> kernel { 0.0625, 0.25, 0.375, 0.25, 0.0625 };

    // Create signal array
    std::vector<double> x(num_pts);
    GenSignal1D(x, c_RngSeed);

    // Create result arrays
    std::vector<double> y1(num_pts);
    std::vector<double> y2(num_pts);

    // Perform 1D convolutions
    bool rc1 = Convolve1D_Ks5_F64_cpp(y1.data(), x.data(), kernel.data(),
        x.size());

    bool rc2 = Convolve1D_Ks5_F64_avx512(y2.data(), x.data(), kernel.data(),
        x.size());

    // Save results
    if (rc1 && rc2)
    {
        std::vector<std::vector<double>*> signal_vectors{ &x, &y1, &y2 };
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
        Convolve1D_Ks5_F64();
        Convolve1D_Ks5_F64_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch15_04 exception: " << ex.what() << '\n';
    }

    return 0;
}
