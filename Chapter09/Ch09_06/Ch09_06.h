//-----------------------------------------------------------------------------
// Ch09_06.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <vector>

// Ch09_06_fasm.asm, Ch09_06_fasm.s
extern "C" void CalcColMeansF64_avx(double* col_means, const double* x,
    size_t nrows, size_t ncols);

// Ch09_06_fcpp.cpp
extern void CalcColMeansF64_cpp(double* col_means, const double* x,
    size_t nrows, size_t ncols);

// Ch09_06_misc.cpp
extern void DisplayResults(std::vector<double>& col_means1,
    std::vector<double>& col_means2, std::vector<double>& x, size_t nrows,
    size_t ncols);

extern void InitMatrix(std::vector<double>& x, size_t nrows, size_t ncols);

// Miscellaneous constants
constexpr size_t c_NumRows = 21;
constexpr size_t c_NumCols = 15;
constexpr unsigned int c_RngSeed = 41;
constexpr double c_MatrixFillMin = 1.0;
constexpr double c_MatrixFillMax = 80.0;
