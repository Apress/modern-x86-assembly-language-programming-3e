//-----------------------------------------------------------------------------
// Ch11_06_fcpp.cpp
//-----------------------------------------------------------------------------

#include <stdexcept>
#include "Ch11_06.h"
#include "MatrixF32.h"
#include "AlignedMem.h"

static bool CheckArgs(const Vec4x1_F32* vec_b, const MatrixF32& m,
    const Vec4x1_F32* vec_a, size_t num_vec)
{
    if (num_vec == 0)
        return false;

    if (m.GetNumRows() != 4 || m.GetNumCols() != 4)
        return false;

    if (!AlignedMem::IsAligned(m.Data(), c_Alignment))
        return false;

    if (!AlignedMem::IsAligned(vec_a, c_Alignment))
        return false;

    if (!AlignedMem::IsAligned(vec_b, c_Alignment))
        return false;

    return true;
}

void MatVecMulF32_cpp(Vec4x1_F32* vec_b, const MatrixF32& m,
    const Vec4x1_F32* vec_a, size_t num_vec)
{
    if (!CheckArgs(vec_b, m, vec_a, num_vec))
        throw std::runtime_error("MatVecMulF32_cpp() - CheckArgs failed");

    const float* mm = m.Data();

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
