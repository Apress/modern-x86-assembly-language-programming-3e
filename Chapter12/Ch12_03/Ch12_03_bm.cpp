//-----------------------------------------------------------------------------
// Ch12_03_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <vector>
#include "Ch12_03.h"
#include "MT_Convolve.h"
#include "BmThreadTimer.h"

void Convolve1D_F32_bm(void)
{
    std::cout << "\nRunning benchmark function Convolve1D_F32_bm() - please wait\n";

    constexpr int64_t num_pts = 2500000;
    const std::vector<float> kernel { 0.0625f, 0.25f, 0.375f, 0.25f, 0.0625f };

    std::vector<float> x(num_pts);
    GenSignal1D(x, c_RngSeed);

    std::vector<float> y0(num_pts);
    std::vector<float> y1(num_pts);

    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        Convolve1D_F32_cpp(y0.data(), x.data(), kernel.data(), x.size(), kernel.size());
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        Convolve1D_F32_avx2(y1.data(), x.data(), kernel.data(), x.size(), kernel.size());
        bmtt.Stop(i, 1);
    }

    std::string fn = bmtt.BuildCsvFilenameString("@Ch12_03_Convolve1D_F32_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times saved to file " << fn << '\n';
}
