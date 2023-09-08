//-----------------------------------------------------------------------------
// Ch09_06.cpp
//-----------------------------------------------------------------------------

#include "Ch09_06.h"

static void CalcColMeansF64(void)
{
    constexpr size_t nrows = c_NumRows;
    constexpr size_t ncols = c_NumCols;
    std::vector<double> x(nrows * ncols);
    std::vector<double> col_means1(ncols);
    std::vector<double> col_means2(ncols);

    InitMatrix(x, nrows, ncols);

    CalcColMeansF64_cpp(col_means1.data(), x.data(), nrows, ncols);
    CalcColMeansF64_avx(col_means2.data(), x.data(), nrows, ncols);

    DisplayResults(col_means1, col_means2, x, nrows, ncols);
}

int main(void)
{
    CalcColMeansF64();
    return 0;
}
