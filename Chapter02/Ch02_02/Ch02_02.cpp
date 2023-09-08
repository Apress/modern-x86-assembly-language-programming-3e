//-----------------------------------------------------------------------------
// Ch02_02.cpp
//-----------------------------------------------------------------------------

#include "Ch02_02.h"

int main()
{
    unsigned int a = 0xffffffff;
    unsigned int b = 0x12345678;
    unsigned int c = 0x87654321;
    unsigned int d = 0x55555555;

    unsigned int r1 = BitOpsU32_cpp(a, b, c, d);
    unsigned int r2 = BitOpsU32_a(a, b, c, d);

    DisplayResults(a, b, c, d, r1, r2);
    return 0;
}
