//-----------------------------------------------------------------------------
// Ch11_03_misc.cpp
//-----------------------------------------------------------------------------

#include <fstream>
#include "Ch11_03.h"
#include "MT.h"

void InitMat(MatrixF64& c1, MatrixF64& c2, MatrixF64& a, MatrixF64& b)
{
    constexpr int rng_min = 2;
    constexpr int rng_max = 50;
    constexpr unsigned int rng_seed_a = 42;
    constexpr unsigned int rng_seed_b = 43;

    MT::FillMatrix(a.Data(), a.GetNumRows(), a.GetNumCols(), rng_min, rng_max,
        rng_seed_a, true);
    MT::FillMatrix(b.Data(), b.GetNumRows(), b.GetNumCols(), rng_min, rng_max,
        rng_seed_b, true);

    constexpr int w = 8;
    c1.SetOstreamW(w);
    c2.SetOstreamW(w);
    a.SetOstreamW(w);
    b.SetOstreamW(w);
}

void SaveResults(const MatrixF64& c1, const MatrixF64& c2, const MatrixF64& a,
    const MatrixF64& b, const char* s)
{
    constexpr char nl = '\n';

    std::string fn("@Ch11_03_MatrixMulF64_");

    if (s != nullptr)
        fn += s;

    fn += OS::GetComputerName();
    fn += std::string(".txt");

    std::ofstream ofs(fn);
    ofs << "\nMatrix a\n" << a << nl;
    ofs << "\nMatrix b\n" << b << nl;
    ofs << "\nMatrix c1\n" << c1 << nl;
    ofs << "\nMatrix c2\n" << c2 << nl;

    ofs.close();

    std::cout << "Matrix multiplication results saved to file " << fn << nl;
}
