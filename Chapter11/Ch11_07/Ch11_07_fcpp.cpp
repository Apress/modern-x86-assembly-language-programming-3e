//-----------------------------------------------------------------------------
// Ch11_07_fcpp.cpp
//-----------------------------------------------------------------------------

#include <stdexcept>
#include "Ch11_07.h"
#include "MatrixF64.h"
#include "AlignedMem.h"

void MatVecMulF64_cpp(Vec4x1_F64* vec_b, const MatrixF64& m,
    const Vec4x1_F64* vec_a, size_t num_vec)
{
    if (!CheckArgs(vec_b, m, vec_a, num_vec))
        throw std::runtime_error("MatVecMulF64_cpp() - CheckArgs failed");

    const double* mm = m.Data();

    // Calculate matrix-vector products
    for (size_t i = 0; i < num_vec; i++)
    {
        vec_b[i].W = mm[0] * vec_a[i].W + mm[1] * vec_a[i].X;
        vec_b[i].W += mm[2] * vec_a[i].Y + mm[3] * vec_a[i].Z;

        vec_b[i].X = mm[4] * vec_a[i].W + mm[5] * vec_a[i].X;
        vec_b[i].X += mm[6] * vec_a[i].Y + mm[7] * vec_a[i].Z;

        vec_b[i].Y = mm[8] * vec_a[i].W + mm[9] * vec_a[i].X;
        vec_b[i].Y += mm[10] * vec_a[i].Y + mm[11] * vec_a[i].Z;

        vec_b[i].Z = mm[12] * vec_a[i].W + mm[13] * vec_a[i].X;
        vec_b[i].Z += mm[14] * vec_a[i].Y + mm[15] * vec_a[i].Z;
    }
}
