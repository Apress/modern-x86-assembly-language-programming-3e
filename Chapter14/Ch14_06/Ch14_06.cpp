//-----------------------------------------------------------------------------
// Ch14_06.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch14_06.h"

static void MatrixMulF64()
{
    constexpr size_t a_nrows = 11;
    constexpr size_t a_ncols = 13;
    constexpr size_t b_nrows = a_ncols;
    constexpr size_t b_ncols = 19;
    constexpr size_t c_nrows = a_nrows;
    constexpr size_t c_ncols = b_ncols;

    MatrixF64 a(a_nrows, a_ncols);
    MatrixF64 b(b_nrows, b_ncols);
    MatrixF64 c1(c_nrows, c_ncols);
    MatrixF64 c2(c_nrows, c_ncols);

    size_t sizes[3];
    sizes[0] = c2.GetNumRows();
    sizes[1] = c2.GetNumCols();
    sizes[2] = a.GetNumCols();

    InitMat(c1, c2, a, b);

    MatrixMulF64_cpp(c1, a, b);
    MatrixMulF64_avx512(c2.Data(), a.Data(), b.Data(), sizes);

    std::cout << "----- Results for Ch14_06 -----\n";

    bool is_equal = MatrixF64::IsEqual(c1, c2, c_Epsilon);

    if (is_equal)
        std::cout << "Matrix compare passed\n";
    else
        std::cout << "Matrix compare FAILED!\n";

    SaveResults(c1, c2, a, b);
}

int main(void)
{
    try
    {
        MatrixMulF64();
        MatrixMulF64_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch14_06 exception: " << ex.what() << '\n';
    }

    return 0;
}
