//-----------------------------------------------------------------------------
// Ch14_08_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch14_08.h"
#include "AlignedMem.h"
#include "BmThreadTimer.h"

void MatrixVecMulF64_bm(void)
{
    std::cout << "\nRunning benchmark function MatrixVecMulF64_bm() - please wait\n";

    constexpr size_t num_vec = 5000000;

    MatrixF64 m(4, 4);
    AlignedArray<Vec4x1_F64> vec_a_aa(num_vec, c_Alignment);
    AlignedArray<Vec4x1_F64> vec_b1_aa(num_vec, c_Alignment);
    AlignedArray<Vec4x1_F64> vec_b2_aa(num_vec, c_Alignment);

    Vec4x1_F64* vec_a = vec_a_aa.Data();
    Vec4x1_F64* vec_b1 = vec_b1_aa.Data();
    Vec4x1_F64* vec_b2 = vec_b2_aa.Data();

    InitData(m, vec_a, num_vec);

    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        MatVecMulF64_cpp(vec_b1, m, vec_a, num_vec);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        MatVecMulF64_avx512(vec_b2, m.Data(), vec_a, num_vec);
        bmtt.Stop(i, 1);

        if (i % 25 == 0)
            std::cout << '.' << std::flush;
    }

    std::cout << '\n';

    std::string fn = bmtt.BuildCsvFilenameString("@Ch14_08_MatrixVecMulF64_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';
}
