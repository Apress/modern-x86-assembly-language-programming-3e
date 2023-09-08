//-----------------------------------------------------------------------------
// Ch11_08.h
//-----------------------------------------------------------------------------

#pragma once
#include <vector>
#include "MatrixF64.h"

// Covariance matrix data (CMD) structure
struct CMD
{
    MatrixF64 m_X;                          // Data matrix (n_vars x n_obvs)
    MatrixF64 m_CovMat;                     // Covariance matrix (n_vars x n_vars)
    std::vector<double> m_VarMeans;         // Variable means (n_vars)

    CMD(size_t n_vars, size_t n_obvs) :
        m_X(n_vars, n_obvs), m_CovMat(n_vars, n_vars), m_VarMeans(n_vars) { }
};

// Ch11_08_fasm.asm, Ch11_08_fasm.s
extern "C" void CalcCovMatF64_avx2(double* cov_mat, double* var_means,
    const double* x, size_t n_vars, size_t n_obvs);

// Ch11_08_fcpp.cpp
extern bool CheckArgs(const CMD& cmd);
extern void CalcCovMatF64_cmd0(CMD& cmd);
extern void CalcCovMatF64_cmd1(CMD& cmd);
extern void CalcCovMatF64_cpp(double* cov_mat, double* var_means,
    const double* x, size_t n_vars, size_t n_ovbs);

// Ch11_08_misc.cpp
extern bool CompareResults(CMD& cmd1, CMD& cmd2);
extern void DisplayData(const CMD& cmd);
extern void InitCMD(CMD& cmd1, CMD& cmd2);

// Ch11_08_bm.cpp
void CalcCovMatF64_bm(void);
