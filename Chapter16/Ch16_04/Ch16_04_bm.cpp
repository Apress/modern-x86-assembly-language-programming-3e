//-----------------------------------------------------------------------------
// Ch16_04_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch16_04.h"
#include "BmThreadTimer.h"

void VecCrossProducts_bm(void)
{
    std::cout << "\nRunning benchmark function VecCrossProducts_bm() - please wait\n";

    VecSOA a, b;
    VecSOA c0, c1, c2;
    constexpr size_t num_vec = c_NumVecBM;

    AllocateTestVectors(&c0, &c1, &c2, &a, &b, num_vec);

    constexpr size_t num_alg = 3;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        VecCrossProducts_cpp(&c0, &a, &b);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        VecCrossProducts_avx2(&c1, &a, &b);
        bmtt.Stop(i, 1);

        bmtt.Start(i, 2);
        VecCrossProductsNT_avx2(&c2, &a, &b);
        bmtt.Stop(i, 2);
    }

    std::cout << '\n';
    std::string fn = bmtt.BuildCsvFilenameString("@Ch16_04_VecCrossProducts_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';

    ReleaseTestVectors(&c0, &c1, &c2, &a, &b);
}
