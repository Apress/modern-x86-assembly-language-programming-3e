//-----------------------------------------------------------------------------
// Ch12_01_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <cstddef>
#include <stdexcept>
#include "Ch12_01.h"
#include "MatrixF32.h"

void DisplayResults(MatrixF32& m_inv, MatrixF32& m_ver, bool rc,
    const char* msg, const char* fn, float epsilon)
{
    constexpr bool round_m_ver = true;

    if (rc)
    {
        std::cout << msg << " - " << fn << " - Inverse matrix\n";
        std::cout << m_inv << '\n';

        // Rounding of m_ver is for display purposes, can be disabled.
        if (round_m_ver)
        {
            m_ver.RoundToI(epsilon);

            for (size_t i = 0; i < 4; i++)
            {
                for (size_t j = 0; j < 4; j++)
                {
                    if (i == j)
                    {
                        if (m_ver.Data()[i * 4 + j] != 1.0f)
                            throw std::runtime_error("DisplayResults() - invalid diagonal element value");
                    }
                    else
                    {
                        if (m_ver.Data()[i * 4 + j] != 0.0f)
                            throw std::runtime_error("DisplayResults() - invalid non-diagonal element value");
                    }
                }
            }
        }

        std::cout << msg << " - " << fn << " - Verification matrix\n";
        std::cout << m_ver << '\n';
    }
    else
        std::cout << msg << " - " << fn << " - Matrix is singular\n";
}
