//-------------------------------------------------
//               MatrixF32.h
//-------------------------------------------------

#pragma once
#include <iostream>
#include <iomanip>
#include <string>
#include <cstring>
#include <stdexcept>
#include <cmath>
#include "AlignedMem.h"

class MatrixF32
{
    static const size_t c_Alignment = 64;

    size_t m_NumRows;
    size_t m_NumCols;
    size_t m_NumElements;
    size_t m_DataSize;
    float* m_Data;

    int m_OstreamW;
    std::string m_OstreamDelim;

    bool IsConforming(size_t num_rows, size_t num_cols) const
    {
        return m_NumRows == num_rows && m_NumCols == num_cols;
    }

    void Allocate(size_t num_rows, size_t num_cols)
    {
        m_NumRows = num_rows;
        m_NumCols = num_cols;
        m_NumElements = m_NumRows * m_NumCols;
        m_DataSize = m_NumElements * sizeof(float);

        if (m_NumElements == 0)
            m_Data = nullptr;
        else
            m_Data = (float*)AlignedMem::Allocate(m_DataSize, c_Alignment);

        SetOstream(10, "  ");
    }

    void Cleanup(void)
    {
        m_NumRows = m_NumCols = m_NumElements = m_DataSize = 0;
        m_Data = nullptr;
    }

    void Release(void)
    {
        if (m_Data != nullptr)
            AlignedMem::Release(m_Data);

        Cleanup();
    }

public:
    MatrixF32(void)
    {
        Allocate(0, 0);
    }

    MatrixF32(size_t num_rows, size_t num_cols)
    {
        Allocate(num_rows, num_cols);
    }

    MatrixF32(size_t num_rows, size_t num_cols, float fill_val)
    {
        Allocate(num_rows, num_cols);
        Fill(fill_val);
    }

    static MatrixF32 I(size_t n)
    {
        MatrixF32 result(n, n);
        result.Fill(0);

        for (size_t i = 0; i < n; i++)
            result.m_Data[i * result.m_NumCols + i] = 1.0;

        return result;
    }

    MatrixF32(const MatrixF32& mat)
    {
        Allocate(mat.m_NumRows, mat.m_NumCols);
        memcpy(m_Data, mat.m_Data, m_DataSize);
        SetOstream(mat.m_OstreamW, mat.m_OstreamDelim);
    }

    MatrixF32(MatrixF32&& mat) noexcept
    {
        m_NumRows = mat.m_NumRows;
        m_NumCols = mat.m_NumCols;
        m_NumElements = mat.m_NumElements;
        m_DataSize = mat.m_DataSize;
        m_Data = mat.m_Data;
        m_OstreamW = mat.m_OstreamW;
        m_OstreamDelim = mat.m_OstreamDelim;

        mat.Cleanup();
    }

    ~MatrixF32()
    {
        Release();
    }

    MatrixF32& operator = (const MatrixF32& mat)
    {
        if (this != &mat)
        {
            if (!IsConforming(*this, mat))
            {
                Release();
                Allocate(mat.m_NumRows, mat.m_NumCols);
            }

            memcpy(m_Data, mat.m_Data, m_DataSize);
            SetOstream(mat.m_OstreamW, mat.m_OstreamDelim);
        }

        return *this;
    }

    MatrixF32& operator = (MatrixF32&& mat) noexcept
    {
        Release();

        m_NumRows = mat.m_NumRows;
        m_NumCols = mat.m_NumCols;
        m_NumElements = mat.m_NumElements;
        m_DataSize = mat.m_DataSize;
        m_Data = mat.m_Data;
        SetOstream(mat.m_OstreamW, mat.m_OstreamDelim);

        mat.Cleanup();
        return *this;
    }

    friend bool operator == (const MatrixF32& mat1, const MatrixF32& mat2)
    {
        if (!IsConforming(mat1, mat2))
            return false;

        return (memcmp(mat1.m_Data, mat2.m_Data, mat1.m_DataSize) == 0) ? true : false;
    }

    friend bool operator != (const MatrixF32& mat1, const MatrixF32& mat2)
    {
        if (!IsConforming(mat1, mat2))
            return false;

        return (memcmp(mat1.m_Data, mat2.m_Data, mat1.m_DataSize) != 0) ? true : false;
    }

    float* Data(void) { return m_Data; }
    const float* Data(void) const { return m_Data; }
    size_t GetNumRows(void) const { return m_NumRows; }
    size_t GetNumCols(void) const { return m_NumCols; }
    size_t GetNumElements(void) const { return m_NumElements; }
    bool IsSquare(void) const { return m_NumRows == m_NumCols; }

    friend MatrixF32 operator + (const MatrixF32& mat1, const MatrixF32& mat2)
    {
        if (!IsConforming(mat1, mat2))
            throw std::runtime_error("Non-conforming operands: operator +");

        MatrixF32 result(mat1.m_NumRows, mat1.m_NumCols);

        for (size_t i = 0; i < result.m_NumElements; i++)
            result.m_Data[i] = mat1.m_Data[i] + mat2.m_Data[i];

        return result;
    }

    friend MatrixF32 operator * (const MatrixF32& mat1, const MatrixF32& mat2)
    {
        if (mat1.m_NumCols != mat2.m_NumRows)
            throw std::runtime_error("Non-conforming operands: operator *");

        size_t m = mat1.m_NumCols;
        MatrixF32 result(mat1.m_NumRows, mat2.m_NumCols);

        for (size_t i = 0; i < result.m_NumRows; i++)
        {
            for (size_t j = 0; j < result.m_NumCols; j++)
            {
                float sum = 0.0f;

                for (size_t k = 0; k < m; k++)
                {
                    float val = mat1.m_Data[i * mat1.m_NumCols + k] * mat2.m_Data[k * mat2.m_NumCols + j];
                    sum += val;
                }

                result.m_Data[i * result.m_NumCols + j] = sum;
            }
        }

        return result;
    }

    friend MatrixF32 operator * (const MatrixF32& mat1, float val)
    {
        MatrixF32 result(mat1.m_NumRows, mat1.m_NumCols);

        for (size_t i = 0; i < mat1.m_NumElements; i++)
            result.m_Data[i] = mat1.m_Data[i] * val;

        return result;
    }

    //
    // In some algorithms, static functions are used instead of overloaded
    // operators to avoid inaccurate benchmark performance comparisons.
    //

    static void Add(MatrixF32& result, const MatrixF32& mat1, const MatrixF32& mat2)
    {
        if (!IsConforming(result, mat1) || !IsConforming(mat1, mat2))
            throw std::runtime_error("Non-conforming operands: MatrixF32::Add");

        for (size_t i = 0; i < result.m_NumElements; i++)
            result.m_Data[i] = mat1.m_Data[i] + mat2.m_Data[i];
    }

    static void Add4x4(MatrixF32& result, const MatrixF32& mat1, const MatrixF32& mat2)
    {
#if defined(_DEBUG)
        if (mat1.m_NumRows != 4 || mat1.m_NumCols != 4 || mat2.m_NumRows != 4 || mat2.m_NumCols != 4)
            throw std::runtime_error("Size check #1 failed - MatrixF32::Addl4x4");

        if (result.m_NumRows != 4 || result.m_NumCols != 4)
            throw std::runtime_error("Size check #2 failed - MatrixF32::Add4x4");
#endif

        constexpr size_t nrows = 4;
        constexpr size_t ncols = 4;

        for (size_t i = 0; i < nrows * ncols; i++)
            result.m_Data[i] = mat1.m_Data[i] + mat2.m_Data[i];
    }

    static void Mul(MatrixF32& result, const MatrixF32& mat1, const MatrixF32& mat2)
    {
        if (mat1.m_NumCols != mat2.m_NumRows)
            throw std::runtime_error("Non-conforming operands: MatrixF32::Mul");

        if (result.m_NumRows != mat1.m_NumRows || result.m_NumCols != mat2.m_NumCols)
            throw std::runtime_error("Invalid matrix size: MatrixF32::Mul");

        size_t m = mat1.m_NumCols;

        for (size_t i = 0; i < result.m_NumRows; i++)
        {
            for (size_t j = 0; j < result.m_NumCols; j++)
            {
                float sum = 0.0f;

                for (size_t k = 0; k < m; k++)
                {
                    float val = mat1.m_Data[i * mat1.m_NumCols + k] * mat2.m_Data[k * mat2.m_NumCols + j];
                    sum += val;
                }

                result.m_Data[i * result.m_NumCols + j] = sum;
            }
        }
    }

    static void Mul4x4(MatrixF32& result, const MatrixF32& mat1, const MatrixF32& mat2)
    {
#if defined(_DEBUG)
        if (mat1.m_NumRows != 4 || mat1.m_NumCols != 4 || mat2.m_NumRows != 4 || mat2.m_NumCols != 4)
            throw std::runtime_error("Size check #1 failed - MatrixF32::Mul4x4");

        if (result.m_NumRows != 4 || result.m_NumCols != 4)
            throw std::runtime_error("Size check #2 failed - MatrixF32::Mul4x4");
#endif

        constexpr size_t m = 4;
        constexpr size_t nrows = 4;
        constexpr size_t ncols = 4;

        for (size_t i = 0; i < nrows; i++)
        {
            for (size_t j = 0; j < ncols; j++)
            {
                float sum = 0.0f;

                for (size_t k = 0; k < m; k++)
                {
                    float val = mat1.m_Data[i * ncols + k] * mat2.m_Data[k * ncols + j];
                    sum += val;
                }

                result.m_Data[i * result.m_NumCols + j] = sum;
            }
        }
    }

    static void MulScalar(MatrixF32& result, const MatrixF32& mat, float val)
    {
        if (!IsConforming(result, mat))
            throw std::runtime_error("Non-conforming operands: MatrixF32::MulScalar");

        for (size_t i = 0; i < result.m_NumElements; i++)
            result.m_Data[i] = mat.m_Data[i] * val;
    }

    static void Transpose(MatrixF32& result, const MatrixF32& mat1)
    {
        if (result.m_NumRows != mat1.m_NumCols || result.m_NumCols != mat1.m_NumRows)
            throw std::runtime_error("Non-conforming operands: MatrixF32::Transpose");

        for (size_t i = 0; i < result.m_NumRows; i++)
        {
            for (size_t j = 0; j < result.m_NumCols; j++)
                result.m_Data[i * result.m_NumCols + j] = mat1.m_Data[j * mat1.m_NumCols + i];
        }
    }

    static bool IsConforming(const MatrixF32& mat1, const MatrixF32& mat2)
    {
        return mat1.m_NumRows == mat2.m_NumRows && mat1.m_NumCols == mat2.m_NumCols;
    }

    static bool IsEqual(const MatrixF32& mat1, const MatrixF32& mat2, float epsilon)
    {
        if (!IsConforming(mat1, mat2))
            throw std::runtime_error("Non-conforming operands: MatrixF32::IsEqual");

        for (size_t i = 0; i < mat1.m_NumElements; i++)
        {
            if (fabs(mat1.m_Data[i] - mat2.m_Data[i]) > epsilon)
                return false;
        }

        return true;
    }

    void Fill(float val)
    {
        for (size_t i = 0; i < m_NumElements; i++)
            m_Data[i] = val;
    }

    void RoundToZero(float epsilon)
    {
        for (size_t i = 0; i < m_NumElements; i++)
        {
            if (fabs(m_Data[i]) < epsilon)
                m_Data[i] = 0.0f;
        }
    }

    void RoundToI(float epsilon)
    {
        for (size_t i = 0; i < m_NumRows; i++)
        {
            for (size_t j = 0; j < m_NumCols; j++)
            {
                size_t k = i * m_NumCols + j;

                if (i != j)
                {
                    if (fabs(m_Data[k]) < epsilon)
                        m_Data[k] = 0;
                }
                else
                {
                    if (fabs(m_Data[k] - 1.0f) < epsilon)
                        m_Data[k] = 1.0f;
                }
            }
        }
    }

    void SetCol(size_t col, const float* vals)
    {
        if (col >= m_NumCols)
            throw std::runtime_error("Invalid column index: MatrixF32::SetCol()");

        for (size_t i = 0; i < m_NumRows; i++)
            m_Data[i * m_NumCols + col] = vals[i];
    }

    void SetRow(size_t row, const float* vals)
    {
        if (row >= m_NumRows)
            throw std::runtime_error("Invalid row index: MatrixF32::SetRow()");

        for (size_t j = 0; j < m_NumCols; j++)
            m_Data[row * m_NumCols + j] = vals[j];
    }

    void SetI(void)
    {
        if (!IsSquare())
            throw std::runtime_error("Square matrix required: MatrixF32::SetI()");

        for (size_t i = 0; i < m_NumRows; i++)
        {
            for (size_t j = 0; j < m_NumCols; j++)
                m_Data[i * m_NumCols + j] = (i == j) ? 1.0f : 0.0f;
        }
    }

    void SetOstreamW(int w)
    {
        m_OstreamW = w;
    }

    void SetOstream(int w, const std::string& delim)
    {
        m_OstreamW = w;
        m_OstreamDelim = delim;
    }

    float Trace(void) const
    {
        if (!IsSquare())
            throw std::runtime_error("Square matrix required: MatrixF32::Trace()");

        float sum = 0.0f;

        for (size_t i = 0; i < m_NumRows; i++)
            sum += m_Data[i * m_NumCols + i];

        return sum;
    }

    float Trace4x4(void) const
    {
        if (m_NumRows != 4 || m_NumCols != 4)
            throw std::runtime_error("4x4 matrix required: MatrixF32::Trace()");

        float sum = m_Data[0] + m_Data[5] + m_Data[10] + m_Data[15];
        return sum;
    }

    friend std::ostream& operator << (std::ostream& os, const MatrixF32& mat)
    {
        for (size_t i = 0; i < mat.m_NumRows; i++)
        {
            for (size_t j = 0; j < mat.m_NumCols; j++)
            {
                os << std::setw(mat.m_OstreamW) << mat.m_Data[i * mat.m_NumCols + j];

                if (j + 1 < mat.m_NumCols)
                    os << mat.m_OstreamDelim;
            }

            os << std::endl;
        }

        return os;
    }
};
