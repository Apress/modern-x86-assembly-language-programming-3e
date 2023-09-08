//-----------------------------------------------------------------------------
// Ch12_02_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch12_02.h"
#include "MatrixF64.h"
#include "BmThreadTimer.h"

void Mat4x4InvF64_bm(void)
{
    std::cout << "\nRunning benchmark function Mat4x4InvF64_bm() - please wait\n";

    MatrixF64 m(4, 4);
    MatrixF64 m_inv0(4, 4);
    MatrixF64 m_inv1(4, 4);
    constexpr double epsilon = c_Epsilon;

    constexpr double m_row0[] = { 2.000, 7.000, 3.000, 4.000 };
    constexpr double m_row1[] = { 5.000, 9.000, 6.000, 4.750 };
    constexpr double m_row2[] = { 6.500, 3.000, 4.000, 10.00 };
    constexpr double m_row3[] = { 7.000, 5.250, 8.125, 6.000 };
    m.SetRow(0, m_row0);
    m.SetRow(1, m_row1);
    m.SetRow(2, m_row2);
    m.SetRow(3, m_row3);

    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    constexpr size_t num_ops = 100000;

    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        for (size_t j = 0; j < num_ops; j++)
            Mat4x4InvF64_cpp(m_inv0, m, epsilon);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        for (size_t j = 0; j < num_ops; j++)
            Mat4x4InvF64_avx2(m_inv1.Data(), m.Data(), epsilon);
        bmtt.Stop(i, 1);
    }

    std::string fn = bmtt.BuildCsvFilenameString("@Ch12_02_Mat4x4InvF64_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';
}
