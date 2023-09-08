//-----------------------------------------------------------------------------
// Ch14_04.h
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

// Ch14_04_fasm.asm, Ch14_04_fasm.s
extern "C" void CalcCovMatF64_avx512(double* cov_mat, double* var_means,
    const double* x, size_t n_vars, size_t n_obvs);

// Ch14_04_fcpp.cpp
extern void CalcCovMatF64_cmd0(CMD& cmd);
extern void CalcCovMatF64_cmd1(CMD& cmd);

extern void CalcCovMatF64_cpp(double* cov_mat, double* var_means,
    const double* x, size_t n_vars, size_t n_ovbs);

// Ch14_04_misc.cpp
extern bool CheckArgs(const CMD& cmd);
extern bool CompareResults(CMD& cmd1, CMD& cmd2);
extern void DisplayData(const CMD& cmd);
extern void InitCMD(CMD& cmd1, CMD& cmd2);

// Ch14_04_bm.cpp
void CalcCovMatF64_bm(void);
