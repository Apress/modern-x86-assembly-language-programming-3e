//-----------------------------------------------------------------------------
// Ch12_02_fcpp.cpp
//-----------------------------------------------------------------------------

#include <stdexcept>
#include <cmath>
#include "Ch12_02.h"

bool Mat4x4InvF64_cpp(MatrixF64& m_inv, const MatrixF64& m, double epsilon)
{
    constexpr size_t nrows = 4;
    constexpr size_t ncols = 4;

    if (m_inv.GetNumRows() != nrows || m_inv.GetNumCols() != ncols)
        throw std::runtime_error("Mat4x4InvF64_cpp() - invalid matrix size (m_inv)");

    if (m.GetNumRows() != nrows || m.GetNumCols() != ncols)
        throw std::runtime_error("Mat4x4InvF64_cpp() - invalid matrix size (m)");

    // Note: Local matrices in this function are declared static to avoid
    //       MatrixF64 constructor/destructor overhead during benchmarking.
    static MatrixF64 m2(nrows, ncols);
    static MatrixF64 m3(nrows, ncols);
    static MatrixF64 m4(nrows, ncols);
    static MatrixF64 I = MatrixF64::I(nrows);
    static MatrixF64 temp_a(nrows, ncols);
    static MatrixF64 temp_b(nrows, ncols);
    static MatrixF64 temp_c(nrows, ncols);
    static MatrixF64 temp_d(nrows, ncols);

    // Calculate matrix product and trace values
    MatrixF64::Mul(m2, m, m);
    MatrixF64::Mul(m3, m2, m);
    MatrixF64::Mul(m4, m3, m);

    double t1 = m.Trace();
    double t2 = m2.Trace();
    double t3 = m3.Trace();
    double t4 = m4.Trace();

    // Calculate coefficients
    double c1 = -t1;
    double c2 = -1.0 / 2.0 * (c1 * t1 + t2);
    double c3 = -1.0 / 3.0 * (c2 * t1 + c1 * t2 + t3);
    double c4 = -1.0 / 4.0 * (c3 * t1 + c2 * t2 + c1 * t3 + t4);

    // Make sure matrix is not singular
    bool is_singular = (fabs(c4) < epsilon);

    if (!is_singular)
    {
        // Calculate inverse = -1.0 / c4 * (m3 + c1 * m2 + c2 * m + c3 * I)
        MatrixF64::MulScalar(temp_a, I, c3);
        MatrixF64::MulScalar(temp_b, m, c2);
        MatrixF64::MulScalar(temp_c, m2, c1);
        MatrixF64::Add(temp_d, temp_a, temp_b);
        MatrixF64::Add(temp_d, temp_d, temp_c);
        MatrixF64::Add(temp_d, temp_d, m3);
        MatrixF64::MulScalar(m_inv, temp_d, -1.0 / c4);
    }

    return !is_singular;
}

