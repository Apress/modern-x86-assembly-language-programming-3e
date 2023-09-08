//-----------------------------------------------------------------------------
// Ch09_06_fcpp.cpp
//-----------------------------------------------------------------------------

#include "Ch09_06.h"

void CalcColMeansF64_cpp(double* col_means, const double* x, size_t nrows,
    size_t ncols)
{
    // Initialize col_means
    for (size_t j = 0; j < ncols; j++)
        col_means[j] = 0.0;

    // Calculate column sums
    for (size_t i = 0; i < nrows; i++)
    {
        for (size_t j = 0; j < ncols; j++)
            col_means[j] += x[i * ncols + j];
    } 

    // Calculate column means
    for (size_t j = 0; j < ncols; j++)
        col_means[j] /= (double)nrows;
}
