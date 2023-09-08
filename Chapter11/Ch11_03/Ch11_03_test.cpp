//-----------------------------------------------------------------------------
// Ch11_03_test.cpp
//-----------------------------------------------------------------------------

#include <stdexcept>
#include <immintrin.h>
#include "Ch11_03.h"

constexpr uint64_t ZR = 0;
constexpr uint64_t MV = 0x8000000000000000;

// Masks for _mm256_maskload_pd()
alignas(32) constexpr uint64_t c_Mask0[4]{ ZR, ZR, ZR, ZR };
alignas(32) constexpr uint64_t c_Mask1[4]{ MV, ZR, ZR, ZR };
alignas(32) constexpr uint64_t c_Mask2[4]{ MV, MV, ZR, ZR };
alignas(32) constexpr uint64_t c_Mask3[4]{ MV, MV, MV, ZR };

// c_MaskX LUT
const uint64_t* c_MaskMovLUT[4]
{
    c_Mask0, c_Mask1, c_Mask2, c_Mask3
};

static bool CheckArgs(const MatrixF64& c, const MatrixF64& a, const MatrixF64& b)
{
    size_t a_nrows = a.GetNumRows();
    size_t a_ncols = a.GetNumCols();
    size_t b_nrows = b.GetNumRows();
    size_t b_ncols = b.GetNumCols();
    size_t c_nrows = c.GetNumRows();
    size_t c_ncols = c.GetNumCols();

    if (a_ncols != b_nrows)
        return false;

    if (c_nrows != a_nrows)
        return false;

    if (c_ncols != b_ncols)
        return false;

    return true;
}

void MatrixMulF64_test(MatrixF64& c, const MatrixF64& a, const MatrixF64& b)
{
    // The code below implements the same algorithm that's used in the
    // assembly language function MatrixMulF64_avx2().

    if (!CheckArgs(c, a, b))
        throw std::runtime_error("MatrixMulF64_Iavx2() CheckArgs failed");

    const double* aa = a.Data();
    const double* bb = b.Data();
    double* cc = c.Data();
    size_t c_nrows = c.GetNumRows();
    size_t c_ncols = c.GetNumCols();
    size_t a_ncols = a.GetNumCols();
    size_t b_ncols = b.GetNumCols();

    constexpr size_t num_simd_elements = 4;
    const size_t num_residual_cols = c_ncols % num_simd_elements;
    __m256i res_mask = _mm256_load_si256((__m256i*)c_MaskMovLUT[num_residual_cols]);

    // Repeat for each row in c
    for (size_t i = 0; i < c_nrows; i++, aa += a_ncols)
    {
        size_t j = 0;

        // Repeat while there are at least NSE columns in current row of c
        while (j + num_simd_elements <= c_ncols)
        {
            const double* p_aa = aa;                 // &aa[i][0]
            const double* p_bb = &bb[j];             // &bb[0][j]

            __m256d c_vals = _mm256_setzero_pd();

            // Calculate products for c[i][j:j+7]
            for (size_t k = 0; k < a_ncols; k++)
            {
                __m256d a_vals = _mm256_broadcast_sd(p_aa);
                __m256d b_vals = _mm256_loadu_pd(p_bb);

                c_vals = _mm256_fmadd_pd(a_vals, b_vals, c_vals);
                p_aa++;
                p_bb += b_ncols;
            }

            _mm256_storeu_pd(cc, c_vals);
            j += num_simd_elements;
            cc += num_simd_elements;
        }

        if (num_residual_cols)
        {
            const double* p_aa = aa;                 // &aa[i][0]
            const double* p_bb = (double*)&bb[j];    // &bb[0][j]

            __m256d c_vals = _mm256_setzero_pd();

            // Calculate products for c[i][j:j+NRC]
            for (size_t k = 0; k < a_ncols; k++)
            {
                __m256d a_vals = _mm256_broadcast_sd(p_aa);
                __m256d b_vals = _mm256_maskload_pd(p_bb, res_mask);

                c_vals = _mm256_fmadd_pd(a_vals, b_vals, c_vals);
                p_aa++;
                p_bb += b_ncols;
            }

            _mm256_maskstore_pd(cc, res_mask, c_vals);
            cc += num_residual_cols;
        }
    }
}
