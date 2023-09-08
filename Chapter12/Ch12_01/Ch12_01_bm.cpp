//-----------------------------------------------------------------------------
// Ch12_01_bm.h
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch12_01.h"
#include "MatrixF32.h"
#include "BmThreadTimer.h"

void Mat4x4InvF32_bm(void)
{
    std::cout << "\nRunning benchmark function Mat4x4InvF32_bm() - please wait\n";

    MatrixF32 m(4, 4);
    MatrixF32 m_inv0(4, 4);
    MatrixF32 m_inv1(4, 4);
    constexpr float epsilon = c_Epsilon;

    constexpr float m_row0[] = { 2.000f, 7.000f, 3.000f, 4.000f };
    constexpr float m_row1[] = { 5.000f, 9.000f, 6.000f, 4.750f };
    constexpr float m_row2[] = { 6.500f, 3.000f, 4.000f, 10.00f };
    constexpr float m_row3[] = { 7.000f, 5.250f, 8.125f, 6.000f };
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
            Mat4x4InvF32_cpp(m_inv0, m, epsilon);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        for (size_t j = 0; j < num_ops; j++)
            Mat4x4InvF32_avx2(m_inv1.Data(), m.Data(), epsilon);
        bmtt.Stop(i, 1);
    }

    std::string fn = bmtt.BuildCsvFilenameString("@Ch12_01_Mat4x4InvF32_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';
}
