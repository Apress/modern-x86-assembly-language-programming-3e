//-----------------------------------------------------------------------------
// Ch12_02.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <stdexcept>
#include <string>
#include "Ch12_02.h"

void Mat4x4InvF64(const MatrixF64& m, const char* msg)
{
    constexpr int w = c_MatOstreamW;
    const size_t nrows = m.GetNumRows();
    const size_t ncols = m.GetNumCols();

    if (nrows != 4 || ncols != 4)
        throw std::runtime_error("Mat4x4InvF64() - invalid matrix size");

    // Create matrices for inverse and verification
    MatrixF64 m_inv1(nrows, ncols);
    MatrixF64 m_ver1(nrows, ncols);
    m_inv1.SetOstreamW(w);
    m_ver1.SetOstreamW(w);

    MatrixF64 m_inv2(nrows, ncols);
    MatrixF64 m_ver2(nrows, ncols);
    m_inv2.SetOstreamW(w);
    m_ver2.SetOstreamW(w);

    // Display original matrix
    std::cout << '\n' << msg << " - Source test matrix\n";
    std::cout << m << '\n';

    constexpr double epsilon = c_Epsilon;
    const char* fn1 = "Mat4x4InvF64_cpp()";
    const char* fn2 = "Mat4x4InvF64_avx2()";

    // Calculate inverse matrix using Mat4x4InvF64_cpp()
    bool rc1 = Mat4x4InvF64_cpp(m_inv1, m, epsilon);

    if (rc1)
        MatrixF64::Mul(m_ver1, m_inv1, m);

    DisplayResults(m_inv1, m_ver1, rc1, msg, fn1, epsilon);

    // Calculate inverse matrix using Mat4x4InvF64_avx2()
    bool rc2 = Mat4x4InvF64_avx2(m_inv2.Data(), m.Data(), epsilon);

    if (rc2)
        Mat4x4MulF64_avx2(m_ver2.Data(), m_inv2.Data(), m.Data());

    DisplayResults(m_inv2, m_ver2, rc2, msg, fn2, epsilon);

    std::cout << std::string(75, '-') << '\n';
}

static void Mat4x4InvF64(void)
{
    constexpr int w = c_MatOstreamW;

    std::cout << "----- Results for Ch12_02 -----\n";
    std::cout << std::fixed << std::setprecision(8);

    // Test Matrix #1 - Non-Singular
    MatrixF64 m1(4, 4);
    const double m1_row0[] = { 2.000, 7.000, 3.000, 4.000 };
    const double m1_row1[] = { 5.000, 9.000, 6.000, 4.750 };
    const double m1_row2[] = { 6.500, 3.000, 4.000, 10.00 };
    const double m1_row3[] = { 7.000, 5.250, 8.125, 6.000 };
    m1.SetRow(0, m1_row0);
    m1.SetRow(1, m1_row1);
    m1.SetRow(2, m1_row2);
    m1.SetRow(3, m1_row3);
    m1.SetOstreamW(w);
    Mat4x4InvF64(m1, "Test #1");

    // Test Matrix #2 - Non-Singular
    MatrixF64 m2(4, 4);
    const double m2_row0[] = { 0.500,  12.00, 17.25, 4.000 };
    const double m2_row1[] = { 5.000,  2.000, 6.750, 8.000 };
    const double m2_row2[] = { 13.125, 1.000, 3.000, 9.750 };
    const double m2_row3[] = { 16.00,  1.625, 7.000, 0.250 };
    m2.SetRow(0, m2_row0);
    m2.SetRow(1, m2_row1);
    m2.SetRow(2, m2_row2);
    m2.SetRow(3, m2_row3);
    m2.SetOstreamW(w);
    Mat4x4InvF64(m2, "Test #2");

    // Test Matrix #3 - Singular
    MatrixF64 m3(4, 4);
    const double m3_row0[] = { 2.000, 0.000, 0.000, 1.000 };
    const double m3_row1[] = { 0.000, 4.000, 5.000, 0.000 };
    const double m3_row2[] = { 0.000, 0.000, 0.000, 7.000 };
    const double m3_row3[] = { 0.000, 0.000, 0.000, 6.000 };
    m3.SetRow(0, m3_row0);
    m3.SetRow(1, m3_row1);
    m3.SetRow(2, m3_row2);
    m3.SetRow(3, m3_row3);
    m3.SetOstreamW(w);
    Mat4x4InvF64(m3, "Test #3");
}

int main(void)
{
    try
    {
        Mat4x4InvF64();
        Mat4x4InvF64_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch12_02 exception: " << ex.what() << '\n';
    }

    return 0;
}
