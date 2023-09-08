//-----------------------------------------------------------------------------
// Ch11_01_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch11_01.h"
#include "AlignedMem.h"
#include "BmThreadTimer.h"

void CalcLeastSquares_bm(void)
{
    std::cout << "\nRunning benchmark function CalcLeastSquares_bm() - please wait\n";

    constexpr size_t n = 5000000;

    AlignedArray<double> x_aa(n, c_Alignment);
    AlignedArray<double> y_aa(n, c_Alignment);

    double* x = x_aa.Data();
    double* y = y_aa.Data();

    InitArrays(x, y, n);

    double m1, m2;
    double b1, b2;

    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        CalcLeastSquares_cpp(&m1, &b1, x, y, n, c_LsEpsilon);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        CalcLeastSquares_avx2(&m2, &b2, x, y, n, c_LsEpsilon);
        bmtt.Stop(i, 1);
    }

    std::string fn = bmtt.BuildCsvFilenameString("@Ch11_01_CalcLeastSquares_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';
}
