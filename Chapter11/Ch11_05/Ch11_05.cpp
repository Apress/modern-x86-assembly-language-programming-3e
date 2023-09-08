//-----------------------------------------------------------------------------
// Ch11_05.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch11_05.h"

static void MatrixMul4x4F64(void)
{
    constexpr char nl = '\n';
    constexpr size_t nrows = 4;
    constexpr size_t ncols = 4;
    MatrixF64 a(nrows, ncols);
    MatrixF64 b(nrows, ncols);
    MatrixF64 c1(nrows, ncols);
    MatrixF64 c2(nrows, ncols);
    MatrixF64 c3(nrows, ncols);

    InitMat(c1, c2, c3, a, b);

    MatrixMul4x4F64_cpp(c1, a, b);
    MatrixMul4x4F64a_avx2(c2.Data(), a.Data(), b.Data());
    MatrixMul4x4F64b_avx2(c3.Data(), a.Data(), b.Data());

    std::cout << std::fixed << std::setprecision(1);

    std::cout << "\n----- Results for Ch11_05 -----\n";
    std::cout << "Matrix a\n" << a << nl;
    std::cout << "Matrix b\n" << b << nl;
    std::cout << "Matrix c1\n" << c1 << nl;
    std::cout << "Matrix c2\n" << c2 << nl;
    std::cout << "Matrix c3\n" << c3 << nl;

    bool is_equal_12 = MatrixF64::IsEqual(c1, c2, c_Epsilon);
    bool is_equal_23 = MatrixF64::IsEqual(c2, c3, c_Epsilon);

    if (is_equal_12 && is_equal_23)
        std::cout << "Matrix compare passed\n";
    else
        std::cout << "Matrix compare FAILED!\n";
}

int main(void)
{
    try
    {
        MatrixMul4x4F64();
        MatrixMul4x4F64_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch11_05 exception: " << ex.what() << '\n';
    }

    return 0;
}
