//-----------------------------------------------------------------------------
// Ch11_05_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch11_05.h"
#include "BmThreadTimer.h"

void MatrixMul4x4F64_bm(void)
{
    std::cout << "\nRunning benchmark function MatrixMul4x4F64_bm() - please wait\n";

    constexpr size_t nrows = 4;
    constexpr size_t ncols = 4;
    MatrixF64 a(nrows, ncols);
    MatrixF64 b(nrows, ncols);
    MatrixF64 c1(nrows, ncols);
    MatrixF64 c2(nrows, ncols);
    MatrixF64 c3(nrows, ncols);

    InitMat(c1, c2, c3, a, b);

    constexpr size_t num_alg = 3;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    constexpr size_t num_ops = 1000000;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        for (size_t j = 0; j < num_ops; j++)
            MatrixMul4x4F64_cpp(c1, a, b);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        for (size_t j = 0; j < num_ops; j++)
            MatrixMul4x4F64a_avx2(c2.Data(), a.Data(), b.Data());
        bmtt.Stop(i, 1);

        bmtt.Start(i, 2);
        for (size_t j = 0; j < num_ops; j++)
            MatrixMul4x4F64b_avx2(c3.Data(), a.Data(), b.Data());
        bmtt.Stop(i, 2);

        if ((i % 20) == 0)
            std::cout << '.' << std::flush;
    }

    std::cout << '\n';
    std::string fn = bmtt.BuildCsvFilenameString("@Ch11_05_MatrixMul4x4F64_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';
}
