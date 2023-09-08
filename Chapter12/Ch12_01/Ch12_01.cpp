//-----------------------------------------------------------------------------
// Ch12_01.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <stdexcept>
#include <string>
#include "Ch12_01.h"

void Mat4x4InvF32(const MatrixF32& m, const char* msg)
{
    constexpr int w = c_MatOstreamW;
    const size_t nrows = m.GetNumRows();
    const size_t ncols = m.GetNumCols();

    if (nrows != 4 || ncols != 4)
        throw std::runtime_error("Mat4x4InvF32() - invalid matrix size");

    // Create matrices for inverse and verification
    MatrixF32 m_inv1(nrows, ncols);
    MatrixF32 m_ver1(nrows, ncols);
    m_inv1.SetOstreamW(w);
    m_ver1.SetOstreamW(w);

    MatrixF32 m_inv2(nrows, ncols);
    MatrixF32 m_ver2(nrows, ncols);
    m_inv2.SetOstreamW(w);
    m_ver2.SetOstreamW(w);

    // Display original matrix
    std::cout << '\n' << msg << " - Source test matrix\n";
    std::cout << m << '\n';

    constexpr float epsilon = c_Epsilon;
    const char* fn1 = "Mat4x4InvF32_cpp()";
    const char* fn2 = "Mat4x4InvF32_avx2()";

    // Calculate inverse matrix using Mat4x4InvF32_cpp()
    bool rc1 = Mat4x4InvF32_cpp(m_inv1, m, epsilon);

    if (rc1)
        MatrixF32::Mul(m_ver1, m_inv1, m);

    DisplayResults(m_inv1, m_ver1, rc1, msg, fn1, epsilon);

    // Calculate inverse matrix using Mat4x4InvF32_avx2()
    bool rc2 = Mat4x4InvF32_avx2(m_inv2.Data(), m.Data(), epsilon);

    if (rc2)
        Mat4x4MulF32_avx2(m_ver2.Data(), m_inv2.Data(), m.Data());

    DisplayResults(m_inv2, m_ver2, rc2, msg, fn2, epsilon);

    std::cout << std::string(75, '-') << '\n';
}

static void Mat4x4InvF32(void)
{
    constexpr int w = c_MatOstreamW;

    std::cout << "----- Results for Ch12_01 -----\n";
    std::cout << std::fixed << std::setprecision(6);

    // Test Matrix #1 - Non-Singular
    MatrixF32 m1(4, 4);
    const float m1_row0[] = { 2.000f, 7.000f, 3.000f, 4.000f };
    const float m1_row1[] = { 5.000f, 9.000f, 6.000f, 4.750f };
    const float m1_row2[] = { 6.500f, 3.000f, 4.000f, 10.00f };
    const float m1_row3[] = { 7.000f, 5.250f, 8.125f, 6.000f };
    m1.SetRow(0, m1_row0);
    m1.SetRow(1, m1_row1);
    m1.SetRow(2, m1_row2);
    m1.SetRow(3, m1_row3);
    m1.SetOstreamW(w);
    Mat4x4InvF32(m1, "Test #1");

    // Test Matrix #2 - Non-Singular
    MatrixF32 m2(4, 4);
    const float m2_row0[] = { 0.500f,  12.00f, 17.25f, 4.000f };
    const float m2_row1[] = { 5.000f,  2.000f, 6.750f, 8.000f };
    const float m2_row2[] = { 13.125f, 1.000f, 3.000f, 9.750f };
    const float m2_row3[] = { 16.00f,  1.625f, 7.000f, 0.250f };
    m2.SetRow(0, m2_row0);
    m2.SetRow(1, m2_row1);
    m2.SetRow(2, m2_row2);
    m2.SetRow(3, m2_row3);
    m2.SetOstreamW(w);
    Mat4x4InvF32(m2, "Test #2");

    // Test Matrix #3 - Singular
    MatrixF32 m3(4, 4);
    const float m3_row0[] = { 2.000f, 0.000f, 0.000f, 1.000f };
    const float m3_row1[] = { 0.000f, 4.000f, 5.000f, 0.000f };
    const float m3_row2[] = { 0.000f, 0.000f, 0.000f, 7.000f };
    const float m3_row3[] = { 0.000f, 0.000f, 0.000f, 6.000f };
    m3.SetRow(0, m3_row0);
    m3.SetRow(1, m3_row1);
    m3.SetRow(2, m3_row2);
    m3.SetRow(3, m3_row3);
    m3.SetOstreamW(w);
    Mat4x4InvF32(m3, "Test #3");
}

int main(void)
{
    try
    {
        Mat4x4InvF32();
        Mat4x4InvF32_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch12_01 exception: " << ex.what() << '\n';
    }

    return 0;
}
