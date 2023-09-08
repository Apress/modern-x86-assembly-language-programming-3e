//-----------------------------------------------------------------------------
// Ch02_03.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch02_03.h"

int main(void)
{
    int rc;
    unsigned int a, count, a_shl, a_shr;

    std::cout << "----- Results for Ch02_03 -----\n\n";

    a = 3119;
    count = 6;
    rc = ShiftU32_a(&a_shl, &a_shr, a, count);
    DisplayResults("Shift test #1", rc, a, count, a_shl, a_shr);

    a = 0x00800080;
    count = 4;
    rc = ShiftU32_a(&a_shl, &a_shr, a, count);
    DisplayResults("Shift test #2", rc, a, count, a_shl, a_shr);

    a = 0x80000001;
    count = 31;
    rc = ShiftU32_a(&a_shl, &a_shr, a, count);
    DisplayResults("Shift test #3", rc, a, count, a_shl, a_shr);

    a = 0x55555555;
    count = 32;
    rc = ShiftU32_a(&a_shl, &a_shr, a, count);
    DisplayResults("Shift test #4", rc, a, count, a_shl, a_shr);

    return 0;
}
