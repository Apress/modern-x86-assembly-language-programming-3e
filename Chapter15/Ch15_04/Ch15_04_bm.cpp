//-----------------------------------------------------------------------------
// Ch15_04_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <vector>
#include "Ch15_04.h"
#include "MT_Convolve.h"
#include "BmThreadTimer.h"

void Convolve1D_Ks5_F64_bm(void)
{
    std::cout << "\nRunning benchmark function Convolve1D_Ks5_F64_bm() - please wait\n";

    constexpr int64_t num_pts = 2500000;
    const std::vector<double> kernel { 0.0625, 0.25, 0.375, 0.25, 0.0625 };

    std::vector<double> x(num_pts);
    GenSignal1D(x, c_RngSeed);

    std::vector<double> y0(num_pts);
    std::vector<double> y1(num_pts);

    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        Convolve1D_Ks5_F64_cpp(y0.data(), x.data(), kernel.data(), x.size());
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        Convolve1D_Ks5_F64_avx512(y1.data(), x.data(), kernel.data(), x.size());
        bmtt.Stop(i, 1);
    }

    std::string fn = bmtt.BuildCsvFilenameString("@Ch15_04_Convolve1D_Ks5_F64_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times saved to file " << fn << '\n';
}

