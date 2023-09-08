//-----------------------------------------------------------------------------
// Ch09_05.cpp
//-----------------------------------------------------------------------------

#include "Ch09_05.h"
#include "AlignedMem.h"

static void CalcDistances(void)
{
    // Allocate and initialize test arrays
    constexpr size_t n = c_NumPoints;

    AlignedArray<double> x1_aa(n, c_Alignment);
    AlignedArray<double> y1_aa(n, c_Alignment);
    AlignedArray<double> x2_aa(n, c_Alignment);
    AlignedArray<double> y2_aa(n, c_Alignment);
    AlignedArray<double> d1_aa(n, c_Alignment);
    AlignedArray<double> d2_aa(n, c_Alignment);

    double* x1 = x1_aa.Data();
    double* y1 = y1_aa.Data();
    double* x2 = x2_aa.Data();
    double* y2 = y2_aa.Data();
    double* d1 = d1_aa.Data();
    double* d2 = d2_aa.Data();

    InitArrays(x1, y1, x2, y2, n);

    // Calculate distances
    CalcDistances_cpp(d1, x1, y1, x2, y2, n, c_Thresh);
    CalcDistances_avx(d2, x1, y1, x2, y2, n, c_Thresh);

    // Display results
    DisplayResults(d1, d2, x1, y1, x2, y2, n, c_Thresh);
}

int main(void)
{
    CalcDistances();
    return 0;
}

