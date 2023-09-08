//-----------------------------------------------------------------------------
// Ch11_02.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch11_02.h"

static void MatrixMulF32(void)
{
    constexpr size_t a_nrows = 11;
    constexpr size_t a_ncols = 13;
    constexpr size_t b_nrows = a_ncols;
    constexpr size_t b_ncols = 19;
    constexpr size_t c_nrows = a_nrows;
    constexpr size_t c_ncols = b_ncols;

    MatrixF32 a(a_nrows, a_ncols);
    MatrixF32 b(b_nrows, b_ncols);
    MatrixF32 c1(c_nrows, c_ncols);
    MatrixF32 c2(c_nrows, c_ncols);

    size_t sizes[3];
    sizes[0] = c2.GetNumRows();
    sizes[1] = c2.GetNumCols();
    sizes[2] = a.GetNumCols();

    InitMat(c1, c2, a, b);

    MatrixMulF32_cpp(c1, a, b);
    MatrixMulF32_avx2(c2.Data(), a.Data(), b.Data(), sizes);

    std::cout << "----- Results for Ch11_02 -----\n";

    bool is_equal = MatrixF32::IsEqual(c1, c2, c_Epsilon);

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
        MatrixMulF32();
        MatrixMulF32_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch11_02 exception: " << ex.what() << '\n';
    }

    return 0;
}
