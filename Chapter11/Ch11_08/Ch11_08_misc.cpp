//-----------------------------------------------------------------------------
// Ch11_08_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <stdexcept>
#include <algorithm>
#include <random>
#include "Ch11_08.h"
#include "MT.h"     

bool CompareResults(CMD& cmd1, CMD& cmd2)
{
    constexpr double eps = 1.0e-9;
    const size_t n_vars = cmd1.m_CovMat.GetNumRows();

    for (size_t i = 0; i < n_vars; i++)
    {
        if (fabs(cmd1.m_VarMeans[i] - cmd2.m_VarMeans[i]) > eps)
            return false;
    }

    return MatrixF64::IsEqual(cmd1.m_CovMat, cmd2.m_CovMat, eps);
}

void DisplayData(const CMD& cmd)
{
    std::cout << "----- Data matrix ----\n";
    std::cout << cmd.m_X << std::endl;
}

void InitCMD(CMD& cmd1, CMD& cmd2)
{
    constexpr double rng_min = 0.0;
    constexpr double rng_max = 25.0;
    constexpr unsigned int rng_seed = 1111;

    if (!CheckArgs(cmd1) || !CheckArgs(cmd2))
        throw std::runtime_error("InitCMD() - CheckArgs() failed");

    if (!MatrixF64::IsConforming(cmd1.m_X, cmd2.m_X))
        throw std::runtime_error("InitCMD() - non-conforming X matrices");

    if (!MatrixF64::IsConforming(cmd1.m_CovMat, cmd2.m_CovMat))
        throw std::runtime_error("InitCMD() - non-conforming covariance matrices");

    if (cmd1.m_VarMeans.size() != cmd2.m_VarMeans.size())
        throw std::runtime_error("InitCMD() - non-conforming variable mean vectors");

    MT::FillMatrixFP(cmd1.m_X.Data(), cmd1.m_X.GetNumRows(), cmd1.m_X.GetNumCols(), rng_min, rng_max, rng_seed);
    cmd2.m_X = cmd1.m_X;

#if defined(_DEBUG)
    cmd1.m_CovMat.Fill(999.0);
    cmd2.m_CovMat.Fill(888.0);
    std::fill(cmd1.m_VarMeans.begin(), cmd1.m_VarMeans.end(), 777.0);
    std::fill(cmd2.m_VarMeans.begin(), cmd2.m_VarMeans.end(), 666.0);
#endif

    cmd1.m_CovMat.SetOstreamW(6);
    cmd2.m_CovMat.SetOstreamW(6);
}
