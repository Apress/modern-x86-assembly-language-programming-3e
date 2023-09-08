//-----------------------------------------------------------------------------
// Ch02_02_fcpp.cpp
//-----------------------------------------------------------------------------

#include "Ch02_02.h"

unsigned int BitOpsU32_cpp(unsigned int a, unsigned int b, unsigned int c,
    unsigned int d)
{
    // Calculate ~(((a & b) | c ) ^ d)
    unsigned int t1 = a & b;
    unsigned int t2 = t1 | c;
    unsigned int t3 = t2 ^ d;
    unsigned int result = ~t3;

    return result;
}
