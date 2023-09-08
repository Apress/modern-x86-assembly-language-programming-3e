//-----------------------------------------------------------------------------
// Ch11_08_fcpp.cpp
//-----------------------------------------------------------------------------

#include <stdexcept>
#include "Ch11_08.h"

bool CheckArgs(const CMD& cmd)
{
    size_t n_vars = cmd.m_X.GetNumRows();
    size_t n_obvs = cmd.m_X.GetNumCols();

    if (n_vars < 2 || n_obvs < 2)
        return false;

    if (cmd.m_CovMat.GetNumRows() != n_vars)
        return false;

    if (cmd.m_CovMat.GetNumCols() != n_vars)
        return false;

    if (cmd.m_VarMeans.size() != n_vars)
        return false;

    return true;
}

void CalcCovMatF64_cmd0(CMD& cmd)
{
    if (!CheckArgs(cmd))
        throw std::runtime_error("CalcCovMatrixF64_cmd0() - CheckArgs() failed");

    size_t n_vars = cmd.m_X.GetNumRows();
    size_t n_obvs = cmd.m_X.GetNumCols();
    double* cov_mat = cmd.m_CovMat.Data();
    double* x = cmd.m_X.Data();
    double* var_means = cmd.m_VarMeans.data();

    CalcCovMatF64_cpp(cov_mat, var_means, x, n_vars, n_obvs);
}

void CalcCovMatF64_cmd1(CMD& cmd)
{
    if (!CheckArgs(cmd))
        throw std::runtime_error("CalcCovMatrixF64_cmd1() - CheckArgs() failed");

    size_t n_vars = cmd.m_X.GetNumRows();
    size_t n_obvs = cmd.m_X.GetNumCols();
    double* cov_mat = cmd.m_CovMat.Data();
    double* x = cmd.m_X.Data();
    double* var_means = cmd.m_VarMeans.data();

    CalcCovMatF64_avx2(cov_mat, var_means, x, n_vars, n_obvs);
}

void CalcCovMatF64_cpp(double* cov_mat, double* var_means, const double* x,
    size_t n_vars, size_t n_obvs)
{
    // Calculate variable means (rows of cmd.m_X)
    for (size_t i = 0; i < n_vars; i++)
    {
        var_means[i] = 0.0;

        for (size_t j = 0; j < n_obvs; j++)
            var_means[i] += x[i * n_obvs + j];

        var_means[i] /= n_obvs;
    }

    // Calculate covariance matrix
    for (size_t i = 0; i < n_vars; i++)
    {
        for (size_t j = 0; j < n_vars; j++)
        {
            if (i <= j)
            {
                double sum = 0.0;

                for (size_t k = 0; k < n_obvs; k++)
                {
                    double temp1 = x[i * n_obvs + k] - var_means[i];
                    double temp2 = x[j * n_obvs + k] - var_means[j];
                    sum += temp1 * temp2;
                }

                cov_mat[i * n_vars + j] = sum / (n_obvs - 1);
            }
            else
                cov_mat[i * n_vars + j] = cov_mat[j * n_vars + i];
        }
    }
}
