//-----------------------------------------------------------------------------
// Ch12_01_fcpp.cpp
//-----------------------------------------------------------------------------

#include <stdexcept>
#include <cmath>
#include "Ch12_01.h"

bool Mat4x4InvF32_cpp(MatrixF32& m_inv, const MatrixF32& m, float epsilon)
{
    constexpr size_t nrows = 4;
    constexpr size_t ncols = 4;

    if (m_inv.GetNumRows() != nrows || m_inv.GetNumCols() != ncols)
        throw std::runtime_error("Mat4x4InvF32_cpp() - invalid matrix size (m_inv)");

    if (m.GetNumRows() != nrows || m.GetNumCols() != ncols)
        throw std::runtime_error("Mat4x4InvF32_cpp() - invalid matrix size (m)");

    // Note: Local matrices in this function are declared static to avoid
    //       MatrixF32 constructor/destructor overhead during benchmarking.
    static MatrixF32 m2(nrows, ncols);
    static MatrixF32 m3(nrows, ncols);
    static MatrixF32 m4(nrows, ncols);
    static MatrixF32 I = MatrixF32::I(nrows);
    static MatrixF32 temp_a(nrows, ncols);
    static MatrixF32 temp_b(nrows, ncols);
    static MatrixF32 temp_c(nrows, ncols);
    static MatrixF32 temp_d(nrows, ncols);

    // Calculate matrix product and trace values
    MatrixF32::Mul(m2, m, m);
    MatrixF32::Mul(m3, m2, m);
    MatrixF32::Mul(m4, m3, m);

    float t1 = m.Trace();
    float t2 = m2.Trace();
    float t3 = m3.Trace();
    float t4 = m4.Trace();

    // Calculate coefficients
    float c1 = -t1;
    float c2 = -1.0f / 2.0f * (c1 * t1 + t2);
    float c3 = -1.0f / 3.0f * (c2 * t1 + c1 * t2 + t3);
    float c4 = -1.0f / 4.0f * (c3 * t1 + c2 * t2 + c1 * t3 + t4);

    // Make sure matrix is not singular
    bool is_singular = (fabs(c4) < epsilon);

    if (!is_singular)
    {
        // Calculate inverse = -1.0 / c4 * (m3 + c1 * m2 + c2 * m + c3 * I)
        MatrixF32::MulScalar(temp_a, I, c3);
        MatrixF32::MulScalar(temp_b, m, c2);
        MatrixF32::MulScalar(temp_c, m2, c1);
        MatrixF32::Add(temp_d, temp_a, temp_b);
        MatrixF32::Add(temp_d, temp_d, temp_c);
        MatrixF32::Add(temp_d, temp_d, m3);
        MatrixF32::MulScalar(m_inv, temp_d, -1.0f / c4);
    }

    return !is_singular;
}
